module.exports = {
  branches: ["main", "ellis/chore/update-semantic-release"],
  tagFormat: "v${version}-pre",
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github",
    "semantic-release-rubygem",
  ],
  ci: process.env.CI || false,
  dryRun: false,
};
