
## Steps to create smartech base plugin
flutter create --org com.netcore --template=plugin --platforms=android,ios -i objc -a kotlin 'smartech_base'

## Steps to create smartech push plugin
flutter create --org com.netcore --template=plugin --platforms=android,ios -i objc -a kotlin 'smartech_push'

## Steps to create smartech appinbox plugin
flutter create --org com.netcore --template=plugin --platforms=android,ios -i objc -a kotlin 'smartech_appinbox'

## Steps to create smartech app project
flutter create --org com.netcore --platforms=android,ios -i objc -a kotlin 'smartech_app'

## Remove the extra example directory in the plugins
rm -rf smartech_appinbox/example
rm -rf smartech_base/example
rm -rf smartech_push/example