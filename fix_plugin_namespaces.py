#!/usr/bin/env python3
import os
import re
import glob

def fix_plugin_namespace(plugin_path):
    """Add namespace to plugin's build.gradle if missing."""
    build_gradle = os.path.join(plugin_path, 'android', 'build.gradle')
    manifest = os.path.join(plugin_path, 'android', 'src', 'main', 'AndroidManifest.xml')
    
    if not os.path.exists(build_gradle) or not os.path.exists(manifest):
        return False
    
    # Read manifest to get package name
    with open(manifest, 'r') as f:
        manifest_content = f.read()
        package_match = re.search(r'package="([^"]+)"', manifest_content)
        if not package_match:
            return False
        package_name = package_match.group(1)
    
    # Read build.gradle
    with open(build_gradle, 'r') as f:
        gradle_content = f.read()
    
    # Check if namespace already exists
    if 'namespace ' in gradle_content:
        return False
    
    # Add namespace after "android {" line
    gradle_content = re.sub(
        r'(android\s*\{)',
        f'\\1\n    namespace \'{package_name}\'',
        gradle_content,
        count=1
    )
    
    # Write back
    with open(build_gradle, 'w') as f:
        f.write(gradle_content)
    
    print(f"✅ Fixed {os.path.basename(plugin_path)}: {package_name}")
    return True

# Find all plugins in pub-cache
pub_cache = os.path.expanduser('~/.pub-cache')
fixed_count = 0

# Fix hosted plugins
for plugin_dir in glob.glob(f'{pub_cache}/hosted/pub.dev/*'):
    if fix_plugin_namespace(plugin_dir):
        fixed_count += 1

# Fix git plugins
for plugin_dir in glob.glob(f'{pub_cache}/git/*'):
    if fix_plugin_namespace(plugin_dir):
        fixed_count += 1

print(f"\n✅ Fixed {fixed_count} plugins total")
