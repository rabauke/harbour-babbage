/*

Copyright (c) 2016-2021, Heiko Bauke
All rights reserved.

You may use this file under the terms of BSD license as follows:

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.

  * Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#include <QtQuick>
#include <QString>
#include <QObject>
#include <QtQml>
#include <sailfishapp.h>
#include "calculator.hpp"


int main(int argc, char *argv[]) {
  QGuiApplication *app{SailfishApp::application(argc, argv)};
  QString locale{QLocale::system().name()};
  QTranslator *translator{new QTranslator};
  if ((translator->load("harbour-babbage." + locale,
                        "/usr/share/harbour-babbage/translations")))
    app->installTranslator(translator);
  qmlRegisterType<calculator>("harbour.babbage.qmlcomponents", 1, 0, "Calculator");
  QQuickView *view{SailfishApp::createView()};
  view->setSource(SailfishApp::pathTo("qml/harbour-babbage.qml"));
  view->show();
  return app->exec();
}
