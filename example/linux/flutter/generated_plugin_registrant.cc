//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <catcher/catcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) catcher_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CatcherPlugin");
  catcher_plugin_register_with_registrar(catcher_registrar);
}
