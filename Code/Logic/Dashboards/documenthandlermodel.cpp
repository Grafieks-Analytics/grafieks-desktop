#include "documenthandlermodel.h"



DocumentHandlerModel::DocumentHandlerModel()
    : m_target(0)
    , m_doc(0)
    , m_cursorPosition(-1)
    , m_selectionStart(0)
    , m_selectionEnd(0)
{
}

QQuickItem *DocumentHandlerModel::target() { return m_target; }

void DocumentHandlerModel::setTarget(QQuickItem *target)
{
    m_doc = 0;
    m_target = target;
    if (!m_target)
        return;

    QVariant doc = m_target->property("textDocument");
    if (doc.canConvert<QQuickTextDocument*>()) {
        QQuickTextDocument *qqdoc = doc.value<QQuickTextDocument*>();
        if (qqdoc)
            m_doc = qqdoc->textDocument();
    }
    emit targetChanged();
}

void DocumentHandlerModel::setFileUrl(const QUrl &arg)
{
    if (m_fileUrl != arg) {
        m_fileUrl = arg;
        QString fileName = QQmlFile::urlToLocalFileOrQrc(arg);
        if (QFile::exists(fileName)) {
            QFile file(fileName);
            if (file.open(QFile::ReadOnly)) {
                QByteArray data = file.readAll();
                QTextCodec *codec = QTextCodec::codecForHtml(data);
                setText(codec->toUnicode(data));
                if (m_doc)
                    m_doc->setModified(false);
                if (fileName.isEmpty())
                    m_documentTitle = QStringLiteral("untitled.txt");
                else
                    m_documentTitle = QFileInfo(fileName).fileName();

                emit textChanged();
                emit documentTitleChanged();

                reset();
            }
        }
        emit fileUrlChanged();
    }
}

QString DocumentHandlerModel::documentTitle() const
{
    return m_documentTitle;
}

void DocumentHandlerModel::setDocumentTitle(QString arg)
{
    if (m_documentTitle != arg) {
        m_documentTitle = arg;
        emit documentTitleChanged();
    }
}

void DocumentHandlerModel::setText(const QString &arg)
{
    if (m_text != arg) {
        m_text = arg;
        emit textChanged();
    }
}


void DocumentHandlerModel::saveTmpFile(const QString filename)
{

    QLatin1String ext(".html");

    QString tmpFilePath = QCoreApplication::applicationDirPath() + "/" + "tmp/";
    QDir tmpDir(tmpFilePath);

    // Check if tmp directory exists
    if(!tmpDir.exists()){
        QDir().mkdir(tmpFilePath);
    }

    // Save the file
    if(!filename.contains("/")){

        QUrl filePath = tmpFilePath + filename;

        QString localPath = filePath.toEncoded();
        if (!localPath.endsWith(ext))
            localPath += ext;
        QFile f(localPath);
        if (!f.open(QFile::WriteOnly | QFile::Truncate | QFile::NotOpen)) {
            emit error(tr("Cannot save: ") + f.errorString());
            return;
        }
        m_doc->setHtml(m_doc->toHtml());

        f.write(m_doc->toHtml().toLocal8Bit());
        f.close();

        setFileUrl(QUrl::fromLocalFile(localPath));

    } else{
        emit error(tr("Bad filename. Cannot contain `/`"));
        return;
    }
}

QUrl DocumentHandlerModel::fileUrl() const
{
    return m_fileUrl;
}

QString DocumentHandlerModel::text() const
{
    return m_text;
}

void DocumentHandlerModel::setCursorPosition(int position)
{
    if (position == m_cursorPosition)
        return;

    m_cursorPosition = position;

    reset();
}

void DocumentHandlerModel::reset()
{
    emit fontFamilyChanged();
    emit alignmentChanged();
    emit boldChanged();
    emit italicChanged();
    emit underlineChanged();
    emit fontSizeChanged();
    emit textColorChanged();
    emit backgroundColorChanged();
}

QTextCursor DocumentHandlerModel::textCursor() const
{
    if (!m_doc)
        return QTextCursor();

    QTextCursor cursor = QTextCursor(m_doc);
    if (m_selectionStart != m_selectionEnd) {
        cursor.setPosition(m_selectionStart);
        cursor.setPosition(m_selectionEnd, QTextCursor::KeepAnchor);
    } else {
        cursor.setPosition(m_cursorPosition);
    }
    return cursor;
}

void DocumentHandlerModel::mergeFormatOnWordOrSelection(const QTextCharFormat &format)
{
    QTextCursor cursor = textCursor();
    if (!cursor.hasSelection())
        cursor.select(QTextCursor::WordUnderCursor);
    cursor.mergeCharFormat(format);
}

void DocumentHandlerModel::setSelectionStart(int position)
{
    m_selectionStart = position;
}

void DocumentHandlerModel::setSelectionEnd(int position)
{
    m_selectionEnd = position;
}

int DocumentHandlerModel::cursorPosition() const { return m_cursorPosition; }

int DocumentHandlerModel::selectionStart() const { return m_selectionStart; }

int DocumentHandlerModel::selectionEnd() const { return m_selectionEnd; }

void DocumentHandlerModel::setAlignment(Qt::Alignment a)
{
    if (!m_doc)
        return;

    QTextBlockFormat fmt;
    fmt.setAlignment((Qt::Alignment) a);
    QTextCursor cursor = QTextCursor(m_doc);
    cursor.setPosition(m_selectionStart, QTextCursor::MoveAnchor);
    cursor.setPosition(m_selectionEnd, QTextCursor::KeepAnchor);
    cursor.mergeBlockFormat(fmt);
    emit alignmentChanged();
}

Qt::Alignment DocumentHandlerModel::alignment() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return Qt::AlignLeft;
    return textCursor().blockFormat().alignment();
}

bool DocumentHandlerModel::bold() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontWeight() == QFont::Bold;
}

bool DocumentHandlerModel::italic() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontItalic();
}

bool DocumentHandlerModel::underline() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontUnderline();
}

void DocumentHandlerModel::setBold(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontWeight(arg ? QFont::Bold : QFont::Normal);
    mergeFormatOnWordOrSelection(fmt);
    emit boldChanged();
}

void DocumentHandlerModel::setItalic(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontItalic(arg);
    mergeFormatOnWordOrSelection(fmt);
    emit italicChanged();
}

void DocumentHandlerModel::setUnderline(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontUnderline(arg);
    mergeFormatOnWordOrSelection(fmt);
    emit underlineChanged();
}

int DocumentHandlerModel::fontSize() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return 0;
    QTextCharFormat format = cursor.charFormat();
    return format.font().pointSize();
}

void DocumentHandlerModel::setFontSize(int arg)
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;
    QTextCharFormat format;
    format.setFontPointSize(arg);
    mergeFormatOnWordOrSelection(format);
    emit fontSizeChanged();
}

QColor DocumentHandlerModel::textColor() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return QColor(Qt::black);
    QTextCharFormat format = cursor.charFormat();
    return format.foreground().color();
}

QColor DocumentHandlerModel::backgroundColor() const
{
    return m_backgroundColor;
}

void DocumentHandlerModel::setTextColor(const QColor &c)
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;
    QTextCharFormat format;
    format.setForeground(QBrush(c));
    mergeFormatOnWordOrSelection(format);
    emit textColorChanged();
}

void DocumentHandlerModel::setBackgroundColor(const QColor &color)
{

    const QString &bgcolor("bgcolor=\"");
    QString html(m_doc->toHtml());
    int n = html.indexOf(bgcolor, html.indexOf("<body"));
    int k = n + bgcolor.length();

    m_doc->setDefaultStyleSheet("body { background-color: '" + color.name() + "' }");

    if (n >= 0)
        html.replace(n + bgcolor.length(), html.mid(k, html.indexOf("\"", n + bgcolor.length()) - k).length(), color.name());

    m_doc->setHtml(html);
    m_backgroundColor = color.name(); // QColor variable


    // Get the filename
    QFile f(this->fileUrl().toString());
    QFileInfo fileInfo(f.fileName());
    QString filename(fileInfo.fileName());


    emit backgroundColorChanged();
}

QString DocumentHandlerModel::fontFamily() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return QString();
    QTextCharFormat format = cursor.charFormat();
    return format.font().family();
}

void DocumentHandlerModel::setFontFamily(const QString &arg)
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;
    QTextCharFormat format;
    format.setFontFamily(arg);
    mergeFormatOnWordOrSelection(format);
    emit fontFamilyChanged();
}

QStringList DocumentHandlerModel::defaultFontSizes() const
{
    // uhm... this is quite ugly
    QStringList sizes;
    QFontDatabase db;
    const auto standardSizes = db.standardSizes();
    for (int size : standardSizes)
        sizes.append(QString::number(size));
    return sizes;
}
