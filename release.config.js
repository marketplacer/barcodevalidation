module.exports = {
  branches: ['main'],
  tagFormat: 'v${version}',
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/github',
    'semantic-release-rubygem'
  ],
  ci: process.env.CI || false,
  dryRun: false
}
