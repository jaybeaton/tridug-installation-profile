#!/usr/bin/env bash

CONFIG_DIR="../../../config/sync";

if [ ! -f "./tridugdemo.info.yml" ]; then
  echo "*** Error: Script must be run from the base of the TriDUG Demo installation profile."
  exit 1;
fi

if [ ! -d ${CONFIG_DIR} ]; then
  echo "*** Error: Config directory should be located here: ../../../config/sync/"
  exit 1;
fi

# Remove the old config.
rm ./config/install/*;
rm ./config/optional/*;
rm ./config/post-install/*;

# Copy over the site's config.
cp ${CONFIG_DIR}/* ./config/install/;

# Move some config to optional.
mv ./config/install/block.block.* ./config/optional/
mv ./config/install/responsive_image.styles.* ./config/optional/
mv ./config/install/image.style.max_* ./config/optional/
mv ./config/install/core.entity_view_display.node.pet.default.yml ./config/optional/
mv ./config/install/core.entity_view_display.node.pet.featured.yml ./config/optional/
mv ./config/install/core.entity_view_display.node.pet.teaser.yml ./config/optional/
mv ./config/install/core.entity_form_display.node.article.default.yml ./config/optional/
mv ./config/install/core.entity_form_display.node.page.default.yml ./config/optional/
mv ./config/install/core.entity_form_display.node.pet.default.yml ./config/optional/
mv ./config/install/views.view.moderated_content.yml ./config/optional/

# Move workflow config to post-install.
mv ./config/install/workflows.workflow.editorial.yml ./config/post-install/

# Don't want the list of enabled modules.
rm ./config/install/core.extension.yml;

# Don't want devel settings.
rm ./config/install/devel.*.yml;
rm ./config/install/*.devel.yml;

# Remove UUIDs, etc.
# For use on Macs:
find ./config/ -type f -exec sed -i '' '/^uuid: /d' {} \;
find ./config/ -type f -exec sed -i '' '/_core/{N;d;}' {} \;
# For use on Linux:
#find ./config/ -type f -exec sed -i -e '/^uuid: /d' {} \;
#find ./config/ -type f -exec sed -i -e '/_core:/,+1d' {} \;

