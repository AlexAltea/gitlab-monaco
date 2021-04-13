import languages from './languages';

/**
 * Inject the bundle resulting from the line below into any function
 * that is executed only once and with the following variables in scope:
 *
 * - gitlabMonacoInstance:
 *     The Monaco language manager to add the custom languages to.
 *     It frequently appears as `monaco.languages` in the Monaco samples
 *     and documentation.
 *
 * - gitlabMonacoLoadLanguages:
 *     The function responsible the Monaco language manager above and
 *     registering an array of languages in it through the methods.
 *     register(), setMonarchTokensProvider(), setLanguageConfiguration().
 */
gitlabMonacoLoadLanguages(gitlabMonacoInstance, languages);
