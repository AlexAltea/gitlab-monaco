#!/usr/bin/env bash
set -euxo pipefail

# Find Monaco script
PATH_GITLAB=/opt/gitlab/embedded
PATH_MONACO=$(find $PATH_GITLAB -name monaco.*.chunk.js -type f | head -n1)
if [[ -z "$PATH_MONACO" ]]; then
    echo "Could not find Monaco script in $PATH_GITLAB" 1>&2
    exit 1;
fi
echo "Found Monaco script in $PATH_MONACO"

# Install or uninstall
if [[ $1 = "--remove" ]]; then
    # Restore backup if exists
    if [[ ! -f "$PATH_MONACO.bak" ]]; then
        echo "Could not find Monaco backup to restore" 1>&2
        exit 1;
    fi
    mv $PATH_MONACO.bak $PATH_MONACO
    mv $PATH_MONACO.gz.bak $PATH_MONACO.gz
    echo "Uninstallation done!"
else
    # Find Monaco custom language loader
    PATH_LOADER=./dist/loader.bundle.js
    if [[ ! -f "$PATH_LOADER" ]]; then
	echo "Could not find Monaco language loader in $PATH_LOADER" 1>&2
	echo "Please generate it via: npx webpack --config webpack.config.loader.js" 1>&2
	exit 1;
    fi

    # Check if previous installation exists
    if [[ -f "$PATH_MONACO.bak" ]]; then
        echo "Monaco backup already exists, please uninstall first  via: $0 --remove" 1>&2
        exit 1;
    fi
    echo "Creating Monaco backup at $PATH_MONACO.bak"
    cp $PATH_MONACO $PATH_MONACO.bak
    cp $PATH_MONACO.gz $PATH_MONACO.gz.bak

    # Patch monaco
    echo "Patching Monaco script"
    sed -Ei "s|([0-9A-Za-z\._]+)(\.setMonarchTokensProvider)|gitlabMonacoLoad(\1);\1\2|" $PATH_MONACO
    cat > $PATH_MONACO.tmp << EOF
        let gitlabMonacoLoadLanguages = function (instance, languages) {
            languages.forEach(def => {
                instance.register(def);
                instance.setMonarchTokensProvider(def.id, def.language);
                instance.setLanguageConfiguration(def.id, def.conf);
            });
        };
        let gitlabMonacoLoadDone = false;
        let gitlabMonacoLoad = function (gitlabMonacoInstance) {
            if (gitlabMonacoLoadDone) {
                return;
            }
            $(cat $PATH_LOADER)
            gitlabMonacoLoadDone = true;
        };
        $(cat $PATH_MONACO)
EOF
    mv $PATH_MONACO.tmp $PATH_MONACO
    rm $PATH_MONACO.gz
    echo "Installation done!"
fi
