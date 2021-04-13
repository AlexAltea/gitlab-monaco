import languages from './languages';

// External dependencies
import * as monaco from 'monaco-editor';

// Register all languages
languages.forEach(def => {
    const languageId = def.id;
    monaco.languages.register(def);
    monaco.languages.setMonarchTokensProvider(languageId, def.language);
    monaco.languages.setLanguageConfiguration(languageId, def.conf);
});

const sampleCode = `/* Sample MyLang code */
// Type source code in your language here...
class MyClass {
  @attribute
  void main() {
    Console.writeln( "Hello Monarch world\n");
  }
}
`;

// Create editor
monaco.editor.create(document.getElementById('container'), {
    value: sampleCode,
    language: 'mylang',
});

// Set editor language by identifier
function setEditorLanguage(id) {
    console.log(`Changing editor language to: ${id}`)
    let list = document.getElementById('languages');
    list.childNodes.forEach(node => {
        if (node.textContent == id) {
            node.style.backgroundColor = '#101010';
        } else {
            node.style.backgroundColor = '#606060';
        }
    });
}

// Set editor theme based on system settings
function setEditorTheme(prefersDark) {
    if (prefersDark) {
        monaco.editor.setTheme('vs-dark');
    } else {
        monaco.editor.setTheme('vs');
    }
}
if (window.matchMedia) {
    let query = window.matchMedia('(prefers-color-scheme: dark)');
    setEditorTheme(query.matches);
    query.addEventListener('change', e => {
        setEditorTheme(e.matches);
    });
}

// Create selectable list of languages
let list = document.getElementById('languages');
languages.forEach(def => {
    let node = document.createElement('span');
    node.textContent = def.id;
    node.addEventListener('click', () => {
        setEditorLanguage(def.id);
    });
    list.appendChild(node);
});

// Select default language
setEditorLanguage('mylang');
