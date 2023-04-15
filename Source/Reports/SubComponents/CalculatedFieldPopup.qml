import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: calculatedFieldPopup
    width: parent.width * 0.5
    height: 600
    anchors.centerIn: parent

    visible: false
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.whiteColor
    }

    /*
    var formulaKeys = Object.keys(formulajs);
    formulaKeys.forEach((key) => {
        window[key] = formulajs[key];
    });

    console.log(window)
*/

    // Formula.js v 2.6.8
    // Available functions formula.js

    property var funcs : [
    "DATE", "DATEVALUE", "DAY", "DAYS", "DAYS360", "EDATE", "EOMONTH", "HOUR", "MINUTE", "ISOWEEKNUM", "MONTH", "NETWORKDAYS", "NETWORKDAYSINTL", "NOW", "SECOND", "TIME", "TIMEVALUE", "TODAY", "WEEKDAY", "YEAR", "WEEKNUM", "WORKDAY", "WORKDAYINTL", "YEARFRAC",
    "ACCRINT", "CUMIPMT", "CUMPRINC", "DB", "DDB", "DOLLARDE", "DOLLARFR", "EFFECT", "FV", "FVSCHEDULE", "IPMT", "IRR", "ISPMT", "MIRR", "NOMINAL", "NPER", "NPV", "PDURATION", "PMT", "PPMT", "PV", "RATE",
    "BIN2DEC", "BIN2HEX", "BIN2OCT", "BITAND", "BITLSHIFT", "BITOR", "BITRSHIFT", "BITXOR", "COMPLEX", "CONVERT", "DEC2BIN", "DEC2HEX", "DEC2OCT", "DELTA", "ERF", "ERFC", "GESTEP", "HEX2BIN", "HEX2DEC", "HEX2OCT", "IMABS", "IMAGINARY", "IMARGUMENT", "IMCONJUGATE", "IMCOS", "IMCOSH", "IMCOT", "IMCSC", "IMCSCH", "IMDIV", "IMEXP", "IMLN", "IMLOG10", "IMLOG2", "IMPOWER", "IMPRODUCT", "IMREAL", "IMSEC", "IMSECH", "IMSIN", "IMSINH", "IMSQRT", "IMSUB", "IMSUM", "IMTAN", "OCT2BIN", "OCT2DEC", "OCT2HEX",
    "AND", "false", "IF", "IFS", "IFERROR", "IFNA", "NOT", "OR", "SWITCH", "true", "XOR",
    "ABS", "ACOS", "ACOSH", "ACOT", "ACOTH", "AGGREGATE", "ARABIC", "ASIN", "ASINH", "ATAN", "ATAN2", "ATANH", "BASE", "CEILING", "CEILINGMATH", "CEILINGPRECISE", "COMBIN", "COMBINA", "COS", "COSH", "COT", "COTH", "CSC", "CSCH", "DECIMAL", "ERF", "ERFC", "EVEN", "EXP", "FACT", "FACTDOUBLE", "FLOOR", "FLOORMATH", "FLOORPRECISE", "GCD", "INT", "ISEVEN", "ISOCEILING", "ISODD", "LCM", "LN", "LOG", "LOG10", "MOD", "MROUND", "MULTINOMIAL", "ODD", "POWER", "PRODUCT", "QUOTIENT", "RADIANS", "RAND", "RANDBETWEEN", "ROUND", "ROUNDDOWN", "ROUNDUP", "SEC", "SECH", "SIGN", "SIN", "SINH", "SQRT", "SQRTPI", "SUBTOTAL", "SUM", "SUMIF", "SUMIFS", "SUMPRODUCT", "SUMSQ", "SUMX2MY2", "SUMX2PY2", "SUMXMY2", "TAN", "TANH", "TRUNC",
    "AVEDEV", "AVERAGE", "AVERAGEA", "AVERAGEIF", "AVERAGEIFS", "BETADIST", "BETAINV", "BINOMDIST", "CORREL", "COUNT", "COUNTA", "COUNTBLANK", "COUNTIF", "COUNTIFS", "COUNTUNIQUE", "COVARIANCEP", "COVARIANCES", "DEVSQ", "EXPONDIST", "FDIST", "FINV", "FISHER", "FISHERINV", "FORECAST", "FREQUENCY", "GAMMA", "GAMMALN", "GAUSS", "GEOMEAN", "GROWTH", "HARMEAN", "HYPGEOMDIST", "INTERCEPT", "KURT", "LARGE", "LINEST", "LOGNORMDIST", "LOGNORMINV", "MAX", "MAXA", "MEDIAN", "MIN", "MINA", "MODEMULT", "MODESNGL", "NORMDIST", "NORMINV", "NORMSDIST", "NORMSINV", "PEARSON", "PERCENTILEEXC", "PERCENTILEINC", "PERCENTRANKEXC", "PERCENTRANKINC", "PERMUT", "PERMUTATIONA", "PHI", "POISSONDIST", "PROB", "QUARTILEEXC", "QUARTILEINC", "RANKAVG", "RANKEQ", "RSQ", "SKEW", "SKEWP", "SLOPE", "SMALL", "STANDARDIZE", "STDEVA", "STDEVP", "STDEVPA", "STDEVS", "STEYX", "TDIST", "TINV", "TRIMMEAN", "VARA", "VARP", "VARPA", "VARS", "WEIBULLDIST", "ZTEST",
    "CHAR", "CLEAN", "CODE", "CONCATENATE", "EXACT", "FIND", "LEFT", "LEN", "LOWER", "MID", "NUMBERVALUE", "PROPER", "REGEXEXTRACT", "REGEXMATCH", "REGEXREPLACE", "REPLACE", "REPT", "RIGHT", "ROMAN", "SEARCH", "SPLIT", "SUBSTITUTE", "T", "TRIM", "UNICHAR", "UNICODE", "UPPER"
    ]

    // Formulajs example usage
    property var examples : [
    "DATE(2008, 7, 8)", "DATEVALUE('8/22/2011')", "DAY('15-Apr-11')", "DAYS('3/15/11', '2/1/11')", "DAYS360('1-Jan-11', '31-Dec-11')", "EDATE('1/15/11', -1)", "EOMONTH('1/1/11', -3)", "HOUR('7/18/2011 7:45:00 AM')", "MINUTE('2/1/2011 12:45:00 PM')", "ISOWEEKNUM('3/9/2012')", "MONTH('15-Apr-11')", "NETWORKDAYS('10/1/2012', '3/1/2013', ['11/22/2012'])", "NETWORKDAYSINTL('1/1/2006', '2/1/2006', 7, ['1/2/2006'])", "NOW()", "SECOND('2/1/2011 4:48:18 PM')", "TIME(16, 48, 10)", "TIMEVALUE('22-Aug-2011 6:35 AM')", "TODAY()", "WEEKDAY('2/14/2008', 3)", "YEAR('7/5/2008')", "WEEKNUM('3/9/2012', 2)", "WORKDAY('10/1/2008', 151, ['11/26/2008', '12/4/2008'])", "WORKDAYINTL('1/1/2012', 30, 17)", "YEARFRAC('1/1/2012', '7/30/2012', 3)",
    "ACCRINT('01/01/2011', '02/01/2011', '07/01/2014', 0.1, 1000, 1, 0)", "CUMIPMT(0.1/12, 30*12, 100000, 13, 24, 0)", "CUMPRINC(0.1/12, 30*12, 100000, 13, 24, 0)", "DB(1000000, 100000, 6, 1, 6)", "DDB(1000000, 100000, 6, 1, 1.5)", "DOLLARDE(1.1, 16)", "DOLLARFR(1.625, 16)", "EFFECT(0.1, 4)", "FV(0.1/12, 10, -100, -1000, 0)", "FVSCHEDULE(100, [0.09,0.1,0.11])", "IPMT(0.1/12, 6, 2*12, 100000, 1000000, 0)", "IRR([-75000,12000,15000,18000,21000,24000], 0.075)", "ISPMT(0.1/12, 6, 2*12, 100000)", "MIRR([-75000,12000,15000,18000,21000,24000], 0.1, 0.12)", "NOMINAL(0.1, 4)", "NPER(0.1/12, -100, -1000, 10000, 0)", "NPV(0.1, -10000, 2000, 4000, 8000)", "PDURATION(0.1, 1000, 2000)", "PMT(0.1/12, 2*12, 100000, 1000000, 0)", "PPMT(0.1/12, 6, 2*12, 100000, 1000000, 0)", "PV(0.1/12, 2*12, 1000, 10000, 0)", "RATE(2*12, -1000, -10000, 100000, 0, 0.1)",
    "BIN2DEC(101010)", "BIN2HEX(101010)", "BIN2OCT(101010)", "BITAND(42, 24)", "BITLSHIFT(42, 24)", "BITOR(42, 24)", "BITRSHIFT(42, 2)", "BITXOR(42, 24)", "COMPLEX(3, 4)", "CONVERT(64, 'kibyte', 'bit')", "DEC2BIN(42)", "DEC2HEX(42)", "DEC2OCT(42)", "DELTA(42, 42)", "ERF(1)", "ERFC(1)", "GESTEP(42, 24)", "HEX2BIN('2a')", "HEX2DEC('2a')", "HEX2OCT('2a')", "IMABS('3+4i')", "IMAGINARY('3+4i')", "IMARGUMENT('3+4i')", "IMCONJUGATE('3+4i')", "IMCOS('1+i')", "IMCOSH('1+i')", "IMCOT('1+i')", "IMCSC('1+i')", "IMCSCH('1+i')", "IMDIV('1+2i', '3+4i')", "IMEXP('1+i')", "IMLN('1+i')", "IMLOG10('1+i')", "IMLOG2('1+i')", "IMPOWER('1+i', 2)", "IMPRODUCT('1+2i', '3+4i', '5+6i')", "IMREAL('3+4i')", "IMSEC('1+i')", "IMSECH('1+i')", "IMSIN('1+i')", "IMSINH('1+i')", "IMSQRT('1+i')", "IMSUB('3+4i', '1+2i')", "IMSUM('1+2i', '3+4i', '5+6i')", "IMTAN('1+i')", "OCT2BIN('52')", "OCT2DEC('52')", "OCT2HEX('52')",
    "AND(true, false, true)", "FALSE()", "IF(true, 'Hello!', 'Goodbye!')", "IFS(false, 'Hello!', true, 'Goodbye!')", "IFERROR('#DIV/0!', 'Error')", "IFNA('#N/A', 'Error')", "NOT(true)", "OR(true, false, true)", "SWITCH(7, 9, 'Nine', 7, 'Seven')", "TRUE()", "XOR(true, false, true)",
    "ABS(-4)", "ACOS(-0.5)", "ACOSH(10)", "ACOT(2)", "ACOTH(6)", "AGGREGATE(9, 4, [-5,15], [32,'Hello World!'])", "ARABIC('MCMXII')", "ASIN(-0.5)", "ASINH(-2.5)", "ATAN(1)", "ATAN2(-1, -1)", "ATANH(-0.1)", "BASE(15, 2, 10)", "CEILING(-5.5, 2, -1)", "CEILINGMATH(-5.5, 2, -1)", "CEILINGPRECISE(-4.1, -2)", "COMBIN(8, 2)", "COMBINA(4, 3)", "COS(1)", "COSH(1)", "COT(30)", "COTH(2)", "CSC(15)", "CSCH(1.5)", "DECIMAL('FF', 16)", "ERF(1)", "ERFC(1)", "EVEN(-1)", "EXP(1)", "FACT(5)", "FACTDOUBLE(7)", "FLOOR(-3.1)", "FLOORMATH(-4.1, -2, -1)", "FLOORPRECISE(-3.1, -2)", "GCD(24, 36, 48)", "INT(-8.9)", "ISEVEN(-2.5)", "ISOCEILING(-4.1, -2)", "ISODD(-2.5)", "LCM(24, 36, 48)", "LN(86)", "LOG(8, 2)", "LOG10(100000)", "MOD(3, -2)", "MROUND(-10, -3)", "MULTINOMIAL(2, 3, 4)", "ODD(-1.5)", "POWER(5, 2)", "PRODUCT(5, 15, 30)", "QUOTIENT(-10, 3)", "RADIANS(180)", "RAND()", "RANDBETWEEN(-1, 1)", "ROUND(626.3, -3)", "ROUNDDOWN(-3.14159, 2)", "ROUNDUP(-3.14159, 2)", "SEC(45)", "SECH(45)", "SIGN(-0.00001)", "SIN(1)", "SINH(1)", "SQRT(16)", "SQRTPI(2)", "SUBTOTAL(9, [-5,15], [32,'Hello World!'])", "SUM(-5, 15, 32, 'Hello World!')", "SUMIF([2,4,8,16], '&gt;5')", "SUMIFS([2,4,8,16], [1,2,3,4], '&gt;=2', [1,2,4,8], '&lt;=4')", "SUMPRODUCT([[1,2],[3,4]], [[1,0],[0,1]])", "SUMSQ(3, 4)", "SUMX2MY2([1,2], [3,4])", "SUMX2PY2([1,2], [3,4])", "SUMXMY2([1,2], [3,4])", "TAN(1)", "TANH(-2)", "TRUNC(-8.9)",
    "AVEDEV([2,4], [8,16])", "AVERAGE([2,4], [8,16])", "AVERAGEA([2,4], [8,16])", "AVERAGEIF([2,4,8,16], '&gt;5', [1, 2, 3, 4])", "AVERAGEIFS([2,4,8,16], [1,2,3,4], '&gt;=2', [1,2,4,8], '&lt;=4')", "BETADIST(2, 8, 10, true, 1, 3)", "BETAINV(0.6854705810117458, 8, 10, 1, 3)", "BINOMDIST(6, 10, 0.5, false)", "CORREL([3,2,4,5,6], [9,7,12,15,17])", "COUNT([1,2], [3,4])", "COUNTA([1, null, 3, 'a', '', 'c'])", "COUNTBLANK([1, null, 3, 'a', '', 'c'])", "COUNTIF(['Caen', 'Melbourne', 'Palo Alto', 'Singapore'], 'a')", "COUNTIFS([2,4,8,16], [1,2,3,4], '&gt;=2', [1,2,4,8], '&lt;=4')", "COUNTUNIQUE([1,1,2,2,3,3])", "COVARIANCEP([3,2,4,5,6], [9,7,12,15,17])", "COVARIANCES([2,4,8], [5,11,12])", "DEVSQ([2,4,8,16])", "EXPONDIST(0.2, 10, true)", "FDIST(15.2069, 6, 4, false)", "FINV(0.01, 6, 4)", "FISHER(0.75)", "FISHERINV(0.9729550745276566)", "FORECAST(30, [6,7,9,15,21], [20,28,31,38,40])", "FREQUENCY([79,85,78,85,50,81,95,88,97], [70,79,89])", "GAMMA(2.5)", "GAMMALN(10)", "GAUSS(2)", "GEOMEAN([2,4], [8,16])", "GROWTH([2,4,8,16], [1,2,3,4], [5])", "HARMEAN([2,4], [8,16])", "HYPGEOMDIST(1, 4, 8, 20, false)", "INTERCEPT([2,3,9,1,8], [6,5,11,7,5])", "KURT([3,4,5,2,3,4,5,6,4,7])", "LARGE([3,5,3,5,4,4,2,4,6,7], 3)", "LINEST([1,9,5,7], [0,4,2,3], true, true)", "LOGNORMDIST(4, 3.5, 1.2, true)", "LOGNORMINV(0.0390835557068005, 3.5, 1.2, true)", "MAX([0.1,0.2], [0.4,0.8], [true, false])", "MAXA([0.1,0.2], [0.4,0.8], [true, false])", "MEDIAN([1,2,3], [4,5,6])", "MIN([0.1,0.2], [0.4,0.8], [true, false])", "MINA([0.1,0.2], [0.4,0.8], [true, false])", "MODEMULT([1,2,3,4,3,2,1,2,3])", "MODESNGL([1,2,3,4,3,2,1,2,3])", "NORMDIST(42, 40, 1.5, true)", "NORMINV(0.9087887802741321, 40, 1.5)", "NORMSDIST(1, true)", "NORMSINV(0.8413447460685429)", "PEARSON([9,7,5,3,1], [10,6,1,5,3])", "PERCENTILEEXC([1,2,3,4], 0.3)", "PERCENTILEINC([1,2,3,4], 0.3)", "PERCENTRANKEXC([1,2,3,4], 2, 2)", "PERCENTRANKINC([1,2,3,4], 2, 2)", "PERMUT(100, 3)", "PERMUTATIONA(4, 3)", "PHI(0.75)", "POISSONDIST(2, 5, true)", "PROB([1,2,3,4], [0.1,0.2,0.2,0.1], 2, 3)", "QUARTILEEXC([1,2,3,4], 1)", "QUARTILEINC([1,2,3,4], 1)", "RANKAVG(4, [2,4,4,8,8,16], false)", "RANKEQ(4, [2,4,4,8,8,16], false)", "RSQ([9,7,5,3,1], [10,6,1,5,3])", "SKEW([3,4,5,2,3,4,5,6,4,7])", "SKEWP([3,4,5,2,3,4,5,6,4,7])", "SLOPE([1,9,5,7], [0,4,2,3])", "SMALL([3,5,3,5,4,4,2,4,6,7], 3)", "STANDARDIZE(42, 40, 1.5)", "STDEVA([2,4], [8,16], [true, false])", "STDEVP([2,4], [8,16], [true, false])", "STDEVPA([2,4], [8,16], [true, false])", "STDEVS([2,4], [8,16], [true, false])", "STEYX([2,3,9,1,8,7,5], [6,5,11,7,5,4,4])", "TDIST(60, 1, true)", "TINV(0.9946953263673741, 1)", "TRIMMEAN([4,5,6,7,2,3,4,5,1,2,3], 0.2)", "VARA([2,4], [8,16], [true, false])", "VARP([2,4], [8,16], [true, false])", "VARPA([2,4], [8,16], [true, false])", "VARS([2,4], [8,16], [true, false])", "WEIBULLDIST(105, 20, 100, true)", "ZTEST([3,6,7,8,6,5,4,2,1,9], 4)",
    "CHAR(65)", "CLEAN('Monthly report')", "CODE('A')", "CONCATENATE('Andreas', ' ', 'Hauser')", "EXACT('Word', 'word')", "FIND('M', 'Miriam&nbsp;McGovern', 3)", "LEFT('Sale Price', 4)", "LEN('Phoenix, AZ')", "LOWER('E. E. Cummings')", "MID('Fluid Flow', 7, 20)", "NUMBERVALUE('2.500,27', ',', '.')", "PROPER('this is a TITLE')", "REGEXEXTRACT('Palo Alto', 'Alto')", "REGEXMATCH('Palo Alto', 'Alto')", "REGEXREPLACE('Sutoiku', 'utoiku', 'TOIC')", "REPLACE('abcdefghijk', 6, 5, '*')", "REPT('*-', 3)", "RIGHT('Sale Price', 5)", "ROMAN(499)", "SEARCH('margin', 'Profit Margin')", "SPLIT('A,B,C', ',')", "SUBSTITUTE('Quarter 1, 2011', '1', '2', 3)", "T('Rainfall')", "TRIM(' First Quarter Earnings ')", "UNICHAR(66)", "UNICODE('B')", "UPPER('total')"
    ]

    // Formulajs example usage data output
    property var out : [
    "Tue Jul 08 2008 00:00:00 GMT-0700 (PDT)","Mon Aug 22 2011 00:00:00 GMT-0700 (PDT)","15","42","360","Wed Dec 15 2010 00:00:00 GMT-0800 (PST)","Sun Oct 31 2010 00:00:00 GMT-0700 (PDT)","7","45","10","4","109","23","Thu Feb 20 2020 23:02:55 GMT+0100 (Central European Standard Time)","18","0.7001157407","0.2743055556","Thu Feb 20 2020 23:02:55 GMT+0100 (Central European Standard Time)","3","2008","11","Mon May 04 2009 00:00:00 GMT-0700 (PDT)","Sun Feb 05 2012 00:00:00 GMT-0800 (PST)","0.5780821918",
    "350","-9916.772514","-614.0863271","159500","250000","1.625","1.1","0.1038128906","2124.874409","133.089","928.8235718","0.05715142887","-625","0.07971710361","0.09645475634","63.39385423","1031.350318","7.272540897","-42426.08564","-43354.90921","-29864.95026","0.06517891177",
    "42","2a","52","8","704643072","58","10","50","3+4i","524288","101010","2a","52","1","0.8427007929","0.1572992071","1","101010","42","52","5","4","0.927295218","3-4i","0.8337300251311491-0.9888977057628651i","0.8337300251311491+0.9888977057628651i","0.21762156185440265-0.8680141428959249i","0.6215180171704283-0.3039310016284264i","0.3039310016284264-0.6215180171704283i","0.44+0.08i","1.4686939399158851+2.2873552871788423i","0.3465735902799727+0.7853981633974483i","0.1505149978319906+0.3410940884604603i","0.5000000000000001+1.1330900354567985i","1.2246063538223775e-16+2.0000000000000004i","-85+20i","3","0.4983370305551868+0.591083841721045i","0.4983370305551868-0.591083841721045i","1.2984575814159773+0.6349639147847361i","0.6349639147847361+1.2984575814159773i","1.0986841134678098+0.45508986056222733i","2+2i","9+12i","0.2717525853195117+1.0839233273386946i","101010","42","2a",
    "FALSE","FALSE","Hello!","Goodbye!","Error","Error","FALSE","TRUE","Seven","TRUE","FALSE",
    "4","2.094395102","2.993222846","0.463647609","0.1682361183","10,32","1912","-0.5235987756","-1.647231146","0.7853981634","-2.35619449","-0.1003353477","1111","-6","-6","-4","28","20","0.5403023059","1.543080635","-0.1561199522","1.037314721","1.537780562","0.4696424406","255","0.8427007929","0.1572992071","-2","2.718281828","120","105","-4","-4","-4","12","-9","TRUE","-4","FALSE","144","4.454347296","3","5","-1","-9","1260","-3","25","2250","-3","3.141592654","[Random real number greater between 0 and 1]","[Random integer between bottom and top]","1000","-3.14","-3.15","1.903594407","5.73E-20","-1","0.8414709848","1.175201194","4","2.506628275","10,32","42","24","12","5","25","-20","30","8","1.557407725","-0.9640275801","-8",
    "4.5","7.5","7.5","3.5","6","0.685470581","2","0.205078125","0.9970544855","4","4","2","3","2","3","5.2","9.666666667","115","0.8646647168","0.001223791709","0.1093099141","0.9729550745","0.75","10.60725309","1,2,4,2","1.329340392","12.80182748","0.4772498681","5.656854249","32","4.266666667","0.3632610939","0.04838709677","-0.1517996372","5","2,1","0.03908355571","4","0.8","1","3.5","0.1","0","2,3","2","0.9087887803","42","0.8413447461","1","0.6993786062","1.5","1.9","0.4","0.33","970200","64","0.3011374322","0.1246520195","0.4","1.25","1.75","4.5","4","0.4891304348","0.3595430714","0.3031933394","2","3","1.333333333","6.013872851","5.361902647","5.489889697","6.191391874","3.30571895","0.9946953264","60","3.777777778","36.16666667","28.75","30.13888889","38.33333333","0.9295813901","0.09057419685",
    "A","Monthly report","65","Andreas Hauser","FALSE","8","Sale","11","e. e. cummings","Flow","2500.27","This Is A Title","Alto","TRUE","STOIC","abcde*k","*-*-*-","Price","CDXCIX","8","A,B,C","Quarter 1, 2012","Rainfall","First Quarter Earnings","B","66","TOTAL"
    ]



    // Listmodel for combobox
    ListModel{
        id: calculations

        ListElement{
            calculationName:"Number"
        }
        ListElement{
            calculationName:"String"
        }
        ListElement{
            calculationName:"Date"
        }
        ListElement{
            calculationName:"Date Conversion"
        }
        ListElement{
            calculationName:"Logical"
        }
        ListElement{
            calculationName:"Aggregate"
        }
        ListElement{
            calculationName:"User"
        }
        ListElement{
            calculationName:"Table Calculation"
        }

    }



    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function onCancelClicked(){
        calculatedFieldPopup.visible = false
    }
    function onApplyClicked(){
        webEngineViewTable.runJavaScript("drawTable("+ tableData +
            ","+JSON.stringify(tableHeaders)+")");

    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts




    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts





    // Popup Header Starts

    Rectangle{

        id: header
        color: Constants.themeColor
        height: 40
        width: parent.width - 2

        anchors.top: parent.top
        anchors.left: parent.left

        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            text: Constants.reportCalculatedFieldPopup
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "/Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: onCancelClicked()
            }
        }

    }

    // Popup Header Ends

    Row{
        id: popupContent
        anchors.top: header.bottom
        width: parent.width - this.padding - this.spacing
        height: parent.height - header.height - footer.height
        padding: 20
        spacing: 20

        Rectangle{
            height: parent.height
            width: parent.width

            Column{
                anchors.fill: parent
                spacing: 10

                Rectangle{
                    id: nameFieldRect
                    height: 30
                    width: parent.width

                    Row{
                        spacing: 15
                        anchors.left: parent.left

                        Rectangle{
                            height: parent.parent.height
                            width: nameLabel.width
                            Text {
                                id: nameLabel
                                text: qsTr("Name")
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        TextField{
                            placeholderText: "Enter Name"
                            selectByMouse: true
                            width: 200
                            height: parent.parent.height
                        }
                    }
                }

                Rectangle{
                    height: parent.height - nameFieldRect.height
                    width: parent.width

                    Row{
                        anchors.fill: parent
                        spacing: 20

                        Rectangle{
                            height: parent.height
                            width: parent.width - rightPanel.width - parent.spacing
                            Column{
                                anchors.fill: parent
                                spacing: 10

                                Text {
                                    id: calculationLabel
                                    text: qsTr("Calculation")
                                }

                                Rectangle{
                                    height: parent.height - calculationLabel.height - 4*parent.spacing
                                    width: parent.width
                                    border.color: Constants.darkThemeColor

                                    TextArea{
                                        id:calculatedFieldTextArea
                                        width: parent.width - 20
                                        height: parent.height - 20
                                        inputMethodHints: Qt.ImhNoAutoUppercase
                                    }
                                }
                            }

                        }
                        Rectangle{
                            id: rightPanel
                            height: parent.height
                            width: 220

                            Column{
                                anchors.fill: parent
                                spacing: 10

                                Text {
                                    id: functionsLabel
                                    text: qsTr("Functions")
                                }

                                Rectangle{
                                    height: parent.height - functionsLabel.height - 4*parent.spacing
                                    width: parent.width

                                    Column{
                                        anchors.fill: parent
                                        spacing: 10

                                        Rectangle{
                                            id: functionField
                                            height: 30
                                            width: parent.width

                                            CustomComboBox{

                                                currentIndex: 0
                                                model: calculations
                                                textRole: "calculationName"
                                                width: parent.width
                                                height: parent.height
                                                font.pixelSize: Constants.fontCategoryHeaderMedium
                                                anchors.centerIn: parent
                                            }

                                        }

                                        Rectangle{
                                            id: syntaxLabel
                                            height: 30
                                            width: parent.width
                                            Text {
                                                text: qsTr("Syntax")
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        Rectangle{
                                            height: parent.height - functionField.height - syntaxLabel.height - 2*parent.spacing
                                            width: parent.width

                                            color: Constants.themeColor
                                            border.color: Constants.darkThemeColor

                                        }

                                    }

                                }

                            }

                        }

                    }


                }
            }



        }

    }


    Rectangle{
        id: footer
        anchors.top: popupContent.bottom
        height: 60
        width: parent.width

        Row{
            spacing: 20
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20

            height: parent.height
            width: parent.width

            Rectangle{

                width: parent.width - 280
                height: parent.height

                Row{
                    height: Constants.defaultElementHeight
                    width: parent.width
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle{
                        height: parent.height
                        width: errorLabel.width
                        Text {
                            id: errorLabel
                            text: qsTr("Errors")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    Rectangle{
                        width: parent.width - errorLabel.width - parent.spacing
                        height: parent.height
                        border.color: Constants.darkThemeColor
                        border.width: 1
                    }
                }


            }

            Rectangle{
                height: parent.height
                width: 200

                Row{
                    width: parent.width
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    CustomButton{
                        height: Constants.defaultElementHeight
                        onClicked: onCancelClicked()
                        textValue: Messages.cancelBtnTxtt
                    }
                    CustomButton{
                        height: Constants.defaultElementHeight
                        textValue: Messages.applyBtnTxt
                        onClicked: onApplyClicked()
                    }
                }

            }

        }

    }

}
