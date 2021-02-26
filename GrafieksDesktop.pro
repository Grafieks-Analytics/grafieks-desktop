QT += quick webengine quickcontrols2 sql networkauth webchannel network axcontainer
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    Code/Connectors/accesscon.cpp \
    Code/Connectors/csvcon.cpp \
    Code/Connectors/excelcon.cpp \
    Code/Connectors/hivecon.cpp \
    Code/Connectors/impalacon.cpp \
    Code/Connectors/mongocon.cpp \
    Code/Connectors/mssqlcon.cpp \
    Code/Connectors/mysqlcon.cpp \
    Code/Connectors/odbccon.cpp \
    Code/Connectors/oraclecon.cpp \
    Code/Connectors/postgrescon.cpp \
    Code/Connectors/redshiftcon.cpp \
    Code/Connectors/snowflakecon.cpp \
    Code/Connectors/sqlitecon.cpp \
    Code/Connectors/teradatacon.cpp \
    Code/Logic/Connectors/Helpers/exceltocsv.cpp \
    Code/Logic/Connectors/Helpers/jsontocsv.cpp \
    Code/Logic/Connectors/box.cpp \
    Code/Logic/Connectors/boxds.cpp \
    Code/Logic/Connectors/boxmodel.cpp \
    Code/Logic/Connectors/connector.cpp \
    Code/Logic/Connectors/connectorfilter.cpp \
    Code/Logic/Connectors/connectormodel.cpp \
    Code/Logic/Connectors/connectorsloginmodel.cpp \
    Code/Logic/Connectors/drive.cpp \
    Code/Logic/Connectors/driveds.cpp \
    Code/Logic/Connectors/drivemodel.cpp \
    Code/Logic/Connectors/dropbox.cpp \
    Code/Logic/Connectors/dropboxds.cpp \
    Code/Logic/Connectors/dropboxmodel.cpp \
    Code/Logic/Connectors/duckcrud.cpp \
    Code/Logic/Connectors/github.cpp \
    Code/Logic/Connectors/githubds.cpp \
    Code/Logic/Connectors/githubmodel.cpp \
    Code/Logic/Connectors/odbcdriversmodel.cpp \
    Code/Logic/Connectors/sheet.cpp \
    Code/Logic/Connectors/sheetds.cpp \
    Code/Logic/Connectors/sheetmodel.cpp \
    Code/Logic/Dashboards/dashboardparamsmodel.cpp \
    Code/Logic/Dashboards/documenthandlermodel.cpp \
    Code/Logic/DataModeller/Helpers/hiveconversions.cpp \
    Code/Logic/DataModeller/Helpers/impalaconversions.cpp \
    Code/Logic/DataModeller/Helpers/mongoconversions.cpp \
    Code/Logic/DataModeller/Helpers/mssqlconversions.cpp \
    Code/Logic/DataModeller/Helpers/mysqlconversions.cpp \
    Code/Logic/DataModeller/Helpers/oracleconversions.cpp \
    Code/Logic/DataModeller/Helpers/postgresconversions.cpp \
    Code/Logic/DataModeller/Helpers/redshiftconversions.cpp \
    Code/Logic/DataModeller/Helpers/snowflakeconversions.cpp \
    Code/Logic/DataModeller/Helpers/sqliteconversions.cpp \
    Code/Logic/DataModeller/Helpers/teradataconversions.cpp \
    Code/Logic/DataModeller/columnlistmodel.cpp \
    Code/Logic/DataModeller/dblistmodel.cpp \
    Code/Logic/DataModeller/dsparamsmodel.cpp \
    Code/Logic/DataModeller/filtercategoricallist.cpp \
    Code/Logic/DataModeller/filtercategoricallistmodel.cpp \
    Code/Logic/DataModeller/filterdatelist.cpp \
    Code/Logic/DataModeller/filterdatelistmodel.cpp \
    Code/Logic/DataModeller/filterfunctionsmodel.cpp \
    Code/Logic/DataModeller/filternumericallist.cpp \
    Code/Logic/DataModeller/filternumericallistmodel.cpp \
    Code/Logic/DataModeller/proxyfiltermodel.cpp \
    Code/Logic/DataModeller/publishdatasourcemodel.cpp \
    Code/Logic/DataModeller/querymodel.cpp \
    Code/Logic/DataModeller/querystatsmodel.cpp \
    Code/Logic/DataModeller/scheduler.cpp \
    Code/Logic/DataModeller/schedulerds.cpp \
    Code/Logic/DataModeller/schedulermodel.cpp \
    Code/Logic/DataModeller/tablelistmodel.cpp \
    Code/Logic/Datasources/datasource.cpp \
    Code/Logic/Datasources/datasourceds.cpp \
    Code/Logic/Datasources/datasourcefilter.cpp \
    Code/Logic/Datasources/datasourcemodel.cpp \
    Code/Logic/General/datatype.cpp \
    Code/Logic/General/generalparamsmodel.cpp \
    Code/Logic/General/qttest.cpp \
    Code/Logic/General/qttest2.cpp \
    Code/Logic/General/querysplitter.cpp \
    Code/Logic/General/tablecolumnsmodel.cpp \
    Code/Logic/General/tableschemamodel.cpp \
    Code/Logic/General/typecheck.cpp \
    Code/Logic/Menu/user.cpp \
    Code/Logic/Reports/duckdata.cpp \
    Code/Logic/Reports/reportmodellist.cpp \
    Code/Logic/Reports/reportparamsmodel.cpp \
    main.cpp \

RESOURCES += \
    images.qrc \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

RC_ICONS = Images/logos/logo.ico
ICON = Images/logos/GrafieksDesktopMac.icns


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Code/Connectors/accesscon.h \
    Code/Connectors/allconnectors.h \
    Code/Connectors/csvcon.h \
    Code/Connectors/excelcon.h \
    Code/Connectors/hivecon.h \
    Code/Connectors/impalacon.h \
    Code/Connectors/mongocon.h \
    Code/Connectors/mssqlcon.h \
    Code/Connectors/mysqlcon.h \
    Code/Connectors/odbccon.h \
    Code/Connectors/oraclecon.h \
    Code/Connectors/postgrescon.h \
    Code/Connectors/redshiftcon.h \
    Code/Connectors/snowflakecon.h \
    Code/Connectors/sqlitecon.h \
    Code/Connectors/teradatacon.h \
    Code/Logic/Connectors/Helpers/exceltocsv.h \
    Code/Logic/Connectors/Helpers/jsontocsv.h \
    Code/Logic/Connectors/box.h \
    Code/Logic/Connectors/boxds.h \
    Code/Logic/Connectors/boxmodel.h \
    Code/Logic/Connectors/connector.h \
    Code/Logic/Connectors/connectorfilter.h \
    Code/Logic/Connectors/connectormodel.h \
    Code/Logic/Connectors/connectorsloginmodel.h \
    Code/Logic/Connectors/drive.h \
    Code/Logic/Connectors/driveds.h \
    Code/Logic/Connectors/drivemodel.h \
    Code/Logic/Connectors/dropbox.h \
    Code/Logic/Connectors/dropboxds.h \
    Code/Logic/Connectors/dropboxmodel.h \
    Code/Logic/Connectors/duckcrud.h \
    Code/Logic/Connectors/github.h \
    Code/Logic/Connectors/githubds.h \
    Code/Logic/Connectors/githubmodel.h \
    Code/Logic/Connectors/odbcdriversmodel.h \
    Code/Logic/Connectors/sheet.h \
    Code/Logic/Connectors/sheetds.h \
    Code/Logic/Connectors/sheetmodel.h \
    Code/Logic/Dashboards/dashboardparamsmodel.h \
    Code/Logic/Dashboards/documenthandlermodel.h \
    Code/Logic/DataModeller/Helpers/hiveconversions.h \
    Code/Logic/DataModeller/Helpers/impalaconversions.h \
    Code/Logic/DataModeller/Helpers/mongoconversions.h \
    Code/Logic/DataModeller/Helpers/mssqlconversions.h \
    Code/Logic/DataModeller/Helpers/mysqlconversions.h \
    Code/Logic/DataModeller/Helpers/oracleconversions.h \
    Code/Logic/DataModeller/Helpers/postgresconversions.h \
    Code/Logic/DataModeller/Helpers/redshiftconversions.h \
    Code/Logic/DataModeller/Helpers/snowflakeconversions.h \
    Code/Logic/DataModeller/Helpers/sqliteconversions.h \
    Code/Logic/DataModeller/Helpers/teradataconversions.h \
    Code/Logic/DataModeller/columnlistmodel.h \
    Code/Logic/DataModeller/dblistmodel.h \
    Code/Logic/DataModeller/dsparamsmodel.h \
    Code/Logic/DataModeller/filtercategoricallist.h \
    Code/Logic/DataModeller/filtercategoricallistmodel.h \
    Code/Logic/DataModeller/filterdatelist.h \
    Code/Logic/DataModeller/filterdatelistmodel.h \
    Code/Logic/DataModeller/filterfunctionsmodel.h \
    Code/Logic/DataModeller/filternumericallist.h \
    Code/Logic/DataModeller/filternumericallistmodel.h \
    Code/Logic/DataModeller/proxyfiltermodel.h \
    Code/Logic/DataModeller/publishdatasourcemodel.h \
    Code/Logic/DataModeller/querymodel.h \
    Code/Logic/DataModeller/querystatsmodel.h \
    Code/Logic/DataModeller/scheduler.h \
    Code/Logic/DataModeller/schedulerds.h \
    Code/Logic/DataModeller/schedulermodel.h \
    Code/Logic/DataModeller/tablelistmodel.h \
    Code/Logic/Datasources/datasource.h \
    Code/Logic/Datasources/datasourceds.h \
    Code/Logic/Datasources/datasourcefilter.h \
    Code/Logic/Datasources/datasourcemodel.h \
    Code/Logic/General/datatype.h \
    Code/Logic/General/generalparamsmodel.h \
    Code/Logic/General/qttest.h \
    Code/Logic/General/qttest2.h \
    Code/Logic/General/querysplitter.h \
    Code/Logic/General/tablecolumnsmodel.h \
    Code/Logic/General/tableschemamodel.h \
    Code/Logic/General/typecheck.h \
    Code/Logic/Menu/user.h \
    Code/Logic/Reports/duckdata.h \
    Code/Logic/Reports/reportmodellist.h \
    Code/Logic/Reports/reportparamsmodel.h \
    Code/ThirdParty/jsoncons/include/jsoncons/json.hpp \
    Code/ThirdParty/jsoncons/include/jsoncons_ext/csv/csv.hpp \
    Code/ThirdParty/jsoncons/jsoncons/allocator_holder.hpp \
    Code/ThirdParty/jsoncons/jsoncons/basic_json.hpp \
    Code/ThirdParty/jsoncons/jsoncons/bigint.hpp \
    Code/ThirdParty/jsoncons/jsoncons/byte_string.hpp \
    Code/ThirdParty/jsoncons/jsoncons/config/binary_config.hpp \
    Code/ThirdParty/jsoncons/jsoncons/config/compiler_support.hpp \
    Code/ThirdParty/jsoncons/jsoncons/config/jsoncons_config.hpp \
    Code/ThirdParty/jsoncons/jsoncons/config/version.hpp \
    Code/ThirdParty/jsoncons/jsoncons/conv_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons/converter.hpp \
    Code/ThirdParty/jsoncons/jsoncons/decode_json.hpp \
    Code/ThirdParty/jsoncons/jsoncons/decode_traits.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/endian.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/grisu3.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/more_type_traits.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/optional.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/parse_number.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/span.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/string_view.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/string_wrapper.hpp \
    Code/ThirdParty/jsoncons/jsoncons/detail/write_number.hpp \
    Code/ThirdParty/jsoncons/jsoncons/encode_json.hpp \
    Code/ThirdParty/jsoncons/jsoncons/encode_traits.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_container_types.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_content_handler.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_cursor.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_decoder.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_encoder.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_exception.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_filter.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_fwd.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_options.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_parser.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_reader.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_traits_macros.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_traits_macros_deprecated.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_type.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_type_traits.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_visitor.hpp \
    Code/ThirdParty/jsoncons/jsoncons/json_visitor2.hpp \
    Code/ThirdParty/jsoncons/jsoncons/pretty_print.hpp \
    Code/ThirdParty/jsoncons/jsoncons/ser_context.hpp \
    Code/ThirdParty/jsoncons/jsoncons/sink.hpp \
    Code/ThirdParty/jsoncons/jsoncons/source.hpp \
    Code/ThirdParty/jsoncons/jsoncons/staj_cursor.hpp \
    Code/ThirdParty/jsoncons/jsoncons/staj_iterator.hpp \
    Code/ThirdParty/jsoncons/jsoncons/tag_type.hpp \
    Code/ThirdParty/jsoncons/jsoncons/unicode_traits.hpp \
    Code/ThirdParty/jsoncons/jsoncons/uri.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson_cursor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson_detail.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson_encoder.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson_options.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson_parser.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/bson_reader.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/decode_bson.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/bson/encode_bson.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor_cursor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor_detail.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor_encoder.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor_options.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor_parser.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/cbor_reader.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/decode_cbor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/cbor/encode_cbor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv_cursor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv_encoder.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv_options.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv_parser.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv_reader.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/csv_serializer.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/decode_csv.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/csv/encode_csv.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jmespath/jmespath.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jmespath/jmespath_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpatch/jsonpatch.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpatch/jsonpatch_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpath/flatten.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpath/json_query.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpath/jsonpath.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpath/jsonpath_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpath/path_expression.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpointer/jsonpointer.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonpointer/jsonpointer_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/format_checkers.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/json_schema_draft7.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/json_validator.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/jsonschema.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/jsonschema_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/schema_keywords.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/schema_loader.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/jsonschema/subschema.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/decode_msgpack.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/encode_msgpack.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack_cursor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack_detail.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack_encoder.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack_options.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack_parser.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/msgpack/msgpack_reader.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/decode_ubjson.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/encode_ubjson.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson_cursor.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson_detail.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson_encoder.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson_error.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson_options.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson_parser.hpp \
    Code/ThirdParty/jsoncons/jsoncons_ext/ubjson/ubjson_reader.hpp \
    Code/duckdb.hpp \
    Code/jsoncons/include/jsoncons/json.hpp \
    Code/jsoncons/include/jsoncons_ext/csv/csv.hpp \
    Code/messages.h \
    Code/constants.h \
    Code/parquet-extension.hpp \
    Code/secrets.h \
    Code/statics.h \


INCLUDEPATH += $$PWD/Libraries
INCLUDEPATH += $$PWD/Libraries/jsoncons
INCLUDEPATH += $$PWD/Libraries/jsoncons_ext
INCLUDEPATH += $$PWD/Libraries/ParquetDuckDb

DEPENDPATH += $$PWD/Libraries

macx: LIBS += -L$$PWD/Libraries/ -lduckdb
win32: LIBS += $$PWD/Libraries/duckdb.lib

macx: LIBS += -L$$PWD/Libraries/ -lparquet_extension
macx: PRE_TARGETDEPS += $$PWD/Libraries/libparquet_extension.a
