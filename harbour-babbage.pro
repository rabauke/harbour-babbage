# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-babbage

CONFIG += c++17
CONFIG += sailfishapp

QMAKE_CXXFLAGS += -std=c++17

SOURCES += src/harbour-babbage.cpp \
    src/calculator.cpp

OTHER_FILES += qml/harbour-babbage.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-babbage.changes.in \
    rpm/harbour-babbage.spec \
    rpm/harbour-babbage.yaml \
    translations/*.ts \
    harbour-babbage.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-babbage.ts \
  translations/harbour-babbage.en.ts \
  translations/harbour-babbage.es.ts \
  translations/harbour-babbage.de.ts

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/pages/About.qml \
    qml/pages/Functions.qml \
    qml/pages/functiondoc.qml \
    qml/components/FunctionDoc.qml \
    qml/pages/Variables.qml \
    qml/pages/SimpleCalculator.qml \
    qml/components/QueryField.qml \
    qml/components/PCButton.qml

images.files = images/cover_background.png
images.path = /usr/share/harbour-babbage/images
INSTALLS += images

HEADERS += \
    src/constants.hpp \
    src/math_parser.hpp \
    src/calculator.hpp \
    src/special_functions.hpp
