#ifndef MESSAGES_H
#define MESSAGES_H

#include <QString>

namespace Messages
{

    // Application level messages
    const QString GeneralSuccessMsg = "Success";
    const QString GeneralFailureMsg = "Failure";
    const QString GeneralNoDriver = "No driver available";
    const QString GeneralTimeOut = "Request Time Out";

    // File Read Status
    const QString fileReadSuccess = "Success";
    const QString fileReadError = "Error reading the file";
    const QString fileTooOld = "File too old";
    const QString fileFormatInvalid = "Invalid file format";

    // Return Statuses
    const int FILE_READ_SUCCESS = 200;
    const int FILE_READ_ERROR = 401;
    const int FILE_FORMAT_ERROR = 403;
    const int FILE_TOO_OLD = 406;

}
#endif // MESSAGES_H
