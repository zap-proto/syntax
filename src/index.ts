/**
 * ZAP Protocol Syntax Highlighting
 *
 * TextMate grammar for ZAP schema files, compatible with:
 * - Shiki (recommended for web)
 * - VS Code
 * - TextMate-compatible editors
 * - Monaco Editor
 */

import grammar from '../syntaxes/zap.tmLanguage.json';
import langConfig from '../language-configuration.json';

export const zapGrammar = grammar;
export const zapLanguageConfiguration = langConfig;

/**
 * Language definition for Shiki
 */
export const zapLanguage = {
  id: 'zap',
  scopeName: 'source.zap',
  grammar: grammar,
  aliases: ['zap', 'zap-protocol', 'ZAP'],
  extensions: ['.zap', '.zaps'],
};

/**
 * Get the ZAP grammar for use with Shiki's loadLanguage
 */
export function getZapGrammar() {
  return {
    ...grammar,
    name: 'zap',
    scopeName: 'source.zap',
  };
}

/**
 * Shiki language registration helper
 *
 * @example
 * ```ts
 * import { createHighlighter } from 'shiki';
 * import { registerZapLanguage } from 'zap-syntax';
 *
 * const highlighter = await createHighlighter({
 *   themes: ['github-dark'],
 *   langs: [],
 * });
 *
 * await registerZapLanguage(highlighter);
 *
 * const html = highlighter.codeToHtml(code, { lang: 'zap' });
 * ```
 */
export async function registerZapLanguage(highlighter: any) {
  await highlighter.loadLanguage({
    name: 'zap',
    scopeName: 'source.zap',
    ...grammar,
  });
}

export default {
  grammar: zapGrammar,
  languageConfiguration: zapLanguageConfiguration,
  language: zapLanguage,
  getZapGrammar,
  registerZapLanguage,
};
