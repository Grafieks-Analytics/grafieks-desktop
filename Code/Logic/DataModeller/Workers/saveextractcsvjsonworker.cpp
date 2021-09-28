#include "saveextractcsvjsonworker.h"

SaveExtractCsvJsonWorker::SaveExtractCsvJsonWorker(FilterCategoricalListModel *categoricalFilter, FilterNumericalListModel *numericalFilter, FilterDateListModel *dateFilter, int totalFiltersCount, QStringList hideParams, QVariantMap changedColumnTypes)
{
    this->categoricalFilter = categoricalFilter;
    this->numericalFilter = numericalFilter;
    this->dateFilter = dateFilter;

    this->totalFiltersCount = totalFiltersCount;
    this->hideParams = hideParams;
    this->changedColumnTypes = changedColumnTypes;

}

bool SaveExtractCsvJsonWorker::appendExtractData(duckdb::Appender *appender)
{
    bool output = true;
    QVector<bool> truthList;

    // Check if filters exist
    // If filters exist, only insert the matched data
    // Else insert any incoming data
    if(this->totalFiltersCount > 0){

        if(this->categoricalFilter != nullptr)
            foreach(FilterCategoricalList *tmpCategoricalFilter, this->categoricalFilter->getFilters()){
                int key = this->columnNamesMap.key(tmpCategoricalFilter->columnName());
                bool returnVar = filterCsvJson.filteredValue(this->dataFinal.at(key), tmpCategoricalFilter->value(), tmpCategoricalFilter->slug());
                truthList.append(returnVar);
            }

        if(this->numericalFilter != nullptr){
            foreach(FilterNumericalList *tmpNumericalFilter, this->numericalFilter->getFilters()){
                int key = this->columnNamesMap.key(tmpNumericalFilter->columnName());
                bool returnVar = filterCsvJson.filteredValue(this->dataFinal.at(key), tmpNumericalFilter->value(), tmpNumericalFilter->slug());
                truthList.append(returnVar);
            }
        }

        if(this->dateFilter != nullptr){
            foreach(FilterDateList *tmpDateFilter, this->dateFilter->getFilters()){
                int key = this->columnNamesMap.key(tmpDateFilter->columnName());
                bool returnVar = filterCsvJson.filteredValue(this->dataFinal.at(key), tmpDateFilter->value(), tmpDateFilter->slug());
                truthList.append(returnVar);
            }
        }


        if(!truthList.contains(false)){
            appender->BeginRow();

            for(int i = 0; i < this->dataFinal.length(); i++){
                if(!rejectIds.contains(i)){

                    QByteArray a = this->dataFinal.at(i);
                    if(this->columnStringTypes.value(i) == "INTEGER"){
                        appender->Append(a.toInt());
                    } else if(this->columnStringTypes.value(i) == "BIGINT"){
                        appender->Append(a.toFloat());
                    } else if(this->columnStringTypes.value(i) == "HUGEINT"){
                        appender->Append(a.toDouble());
                    } else if(this->columnStringTypes.value(i) == "FLOAT"){
                        appender->Append(a.toFloat());
                    } else if(this->columnStringTypes.value(i) == "DOUBLE"){
                        appender->Append(a.toDouble());
                    } else if(this->columnStringTypes.value(i) == "VARCHAR"){
                        appender->Append(a.toStdString().c_str());
                    } else if(this->columnStringTypes.value(i) == "TIMESTAMP"){
                        QString dateTime = a.toStdString().c_str();
                        QDateTime dateTimeVal = QDateTime::fromString(dateTime, this->matchedDateFormats.value(i));

                        QDate date = dateTimeVal.date();
                        QTime time = dateTimeVal.time();
                        int32_t year = date.year();
                        int32_t month = date.month();
                        int32_t day = date.day();
                        qDebug() << "HERE" << typeid(day).name();
                        appender->Append(duckdb::Date::FromDate(year, month, day));

                        // Timestamp in duckDb release crashes. Will fix in the future
                        // appender->Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
                    } else {
                        qDebug() << a.toStdString().c_str();
                    }
                }

            }
            appender->EndRow();
        }

        truthList.clear();
    } else {


        appender->BeginRow();
        for(int i = 0; i < this->dataFinal.length(); i++){


            if(!this->rejectIds.contains(i)){
                QByteArray a = this->dataFinal.at(i);
                if(this->columnStringTypes.value(i) == "INTEGER"){
                    appender->Append(a.toInt());
                } else if(this->columnStringTypes.value(i) == "BIGINT"){
                    appender->Append(a.toFloat());
                } else if(this->columnStringTypes.value(i) == "HUGEINT"){
                    appender->Append(a.toDouble());
                } else if(this->columnStringTypes.value(i) == "FLOAT"){
                    appender->Append(a.toFloat());
                } else if(this->columnStringTypes.value(i) == "DOUBLE"){
                    appender->Append(a.toDouble());
                } else if(this->columnStringTypes.value(i) == "VARCHAR"){
                    appender->Append(a.toStdString().c_str());
                } else if(this->columnStringTypes.value(i) == "TIMESTAMP"){
                    QString dateTime = a.toStdString().c_str();
                    QDateTime dateTimeVal = QDateTime::fromString(dateTime, this->matchedDateFormats.value(i));

                    QDate date = dateTimeVal.date();
                    QTime time = dateTimeVal.time();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender->Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));

                } else {
                    qDebug() << a.toStdString().c_str();
                }
            }
        }
        appender->EndRow();

    }
    return output;
}

QString SaveExtractCsvJsonWorker::createExtractDb(QFile *file, QString fileName, duckdb::Connection con)
{
    QString errorMsg = "";
    QString delimiter = Statics::separator;

    this->rejectIds.clear();

    int lineCount = 0;
    while(lineCount < 2){

        const QByteArray line = file->readLine().simplified();
        this->dataFinal = line.split(*delimiter.toStdString().c_str());

        if(lineCount == 0){

            if (this->dataFinal.at(0).contains("\xEF\xBB\xBF")){
                this->dataFinal[0] =  this->dataFinal.at(0).right(this->dataFinal.at(0).length() - 3);
            }

            for(int i = 0; i < this->dataFinal.length(); i++){
                if(!this->hideParams.contains(this->dataFinal.at(i).toStdString().c_str())){
                    this->columnNamesMap.insert(i, this->dataFinal.at(i).toStdString().c_str());
                } else {
                    this->rejectIds.append(i);
                }
            }

        } else {

            QString createTableQuery = "CREATE TABLE " + fileName + "(";

            for(int i = 0; i < this->dataFinal.length(); i++){
                if(!this->rejectIds.contains(i)){
                    QString varType = dataType.variableType(this->dataFinal.at(i).toStdString().c_str()).at(0);
                    QString matchedFormat = dataType.variableType(this->dataFinal.at(i).toStdString().c_str()).at(1);
                    this->matchedDateFormats.insert(i, matchedFormat);

                    // Check if the user has changed the column type from the Modeler screen
                    // If so, set the users choice as default, else process the other condition
                    QString checkFieldName = fileName + "." + this->columnNamesMap.value(i);

                    if(this->changedColumnTypes.value(checkFieldName).toString() != ""){
                        varType = this->changedColumnTypes.value(checkFieldName).toString();
                    }

                    if(varType == Constants::categoricalType){
                        varType = "VARCHAR";
                    } else if(varType == Constants::numericalType){
                        QString dataLen = this->dataFinal.at(i).toStdString().c_str();

                        if(dataLen.toLower().contains("e-") || dataLen.toLower().contains("e+") || dataLen.toLower().contains(".")){
                            QString s = this->dataFinal.at(i).toStdString().c_str();
                            varType = "DOUBLE";
                        } else {
                            if(dataLen.length() <= 10 && dataLen.toInt() < 2147483647){
                                varType = "INTEGER";
                            } else if(dataLen.length() <= 19 && dataLen.toLong() < 9223372036854775808) {
                                varType = "BIGINT";
                            } else {
                                varType = "HUGEINT";
                            }
                        }

                    } else {
                        varType = "TIMESTAMP";
                    }

                    this->columnStringTypes.insert(i, varType);
                    createTableQuery += "\"" + this->columnNamesMap.value(i) + "\" " + varType + " NULL,";
                }
            }

            createTableQuery.chop(1);
            createTableQuery += ")";


            auto createT = con.Query(createTableQuery.toStdString());
            if(!createT->success) {
                errorMsg = createT->error.c_str();
                qDebug() <<Q_FUNC_INFO << "Error Creating Extract" << createT->error.c_str();
            }
        }

        lineCount++;
    }


    // Create a master table to refer the name of actual extract tableName
    // while running an extract later on

    QString tableCreateQuery = "CREATE TABLE " + Constants::masterExtractTable + "(tableName VARCHAR, app_version VARCHAR, mode VARCHAR, extract_version INTEGER)";
    QString tableInserQuery = "INSERT INTO " + Constants::masterExtractTable + " VALUES ('" + fileName + "', '" + Constants::appVersion + "', '" + Constants::currentMode + "', '" + Constants::extractVersion + "')";

    auto x = con.Query(tableCreateQuery.toStdString());
    if(!x->success) qDebug() << x->error.c_str() << tableCreateQuery;
    auto z = con.Query(tableInserQuery.toStdString());
    if(!z->success) qDebug() << z->error.c_str() << tableInserQuery;


    return errorMsg;
}

void SaveExtractCsvJsonWorker::run()
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;

    // Remove extract file if already exists
    QFile fileRemove(extractPath);
    if(fileRemove.exists()) {
        QString tmpFile = extractPath;
        tmpFile.append(".wal");

        QFile fileTmpRemove(tmpFile);

        fileTmpRemove.remove();
        fileRemove.remove();
    }

    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    QString fileName = QFileInfo(tableName).baseName().toLower();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    QString delimiter = Statics::separator;
    bool ignoredFirstLine = true;

    // Create Extract
    QFile fileCreateExtract(Statics::csvJsonPath);
    fileCreateExtract.open(QFile::ReadOnly | QFile::Text);

    QString createDb = this->createExtractDb(&fileCreateExtract, fileName, con);

    fileCreateExtract.close();

    // Append data to Extract
    if(createDb.length() <= 0){
        QFile fileAppendData(Statics::csvJsonPath);
        fileAppendData.open(QFile::ReadOnly | QFile::Text);

        duckdb::Appender appender(con, fileName.toStdString());
        int lineCounter = 0;
        while(!fileAppendData.atEnd()){

            const QByteArray line = fileAppendData.readLine().simplified();
            this->dataFinal = line.split(*delimiter.toStdString().c_str());

            // Ignore header data to be inserted
            if(ignoredFirstLine == false){
                this->appendExtractData(&appender);
            }

            ignoredFirstLine = false;
            lineCounter++;

            if(lineCounter%Constants::flushExtractCount == 0)
                    appender.Flush();
        }

        appender.Close();

        fileAppendData.close();
    }

    emit saveExtractComplete(createDb);
}
