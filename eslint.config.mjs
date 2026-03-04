import js from '@eslint/js';
import nextConfig from 'eslint-config-next/core-web-vitals';

export default [
  js.configs.recommended,
  ...nextConfig,
  {
    ignores: ['.next/**', 'out/**', 'node_modules/**'],
  },
];
