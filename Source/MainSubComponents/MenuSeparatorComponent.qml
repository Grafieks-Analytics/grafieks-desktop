/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Menu Separator Component
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0

Item{
    id : menuSeparatorComponent
    height: 1
    width: implicitWidth

    MenuSeparator{
        topPadding: 0
        bottomPadding: 0
        leftPadding: 35
        rightPadding: 5
        background: Rectangle{
            color: "#D7D9DF"
        }
    }
}
