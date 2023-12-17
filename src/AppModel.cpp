#include "AppModel.hpp"
#include <QCoreApplication>
#include <QSettings>
#include <QStandardPaths>
#include <QDir>


#ifdef SAILJAIL

namespace {

  QString settings_path() {
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" +
           QCoreApplication::applicationName() + ".conf";
  }

}  // namespace

#endif


AppModel::AppModel(QObject* parent) : QObject{parent} {
#ifdef SAILJAIL
  QSettings settings{settings_path(), QSettings::NativeFormat};
#else
  QSettings settings;
#endif
}


AppModel::~AppModel() {
#ifdef SAILJAIL
  QSettings settings{settings_path(), QSettings::NativeFormat};
#else
  QSettings settings;
#endif
}
