# Changelog

## [0.2.0](https://github.com/vaam-apps/.github/compare/v0.1.0...v0.2.0) (2026-09-19)


### Features

* add ai-governance issue templates ([#2](https://github.com/vaam-apps/.github/issues/2)) ([2f06d3e](https://github.com/vaam-apps/.github/commit/2f06d3e795073f753a68c53f108ebefad163a86a))
* **ci:** add a reusable sync-repo-settings workflow ([#7](https://github.com/vaam-apps/.github/issues/7)) ([686295f](https://github.com/vaam-apps/.github/commit/686295f1641e6cf5c2d38bbff1e5aa59dfdff244))
* **governance:** add org-wide PR template and PR governance workflow ([#4](https://github.com/vaam-apps/.github/issues/4)) ([cdf7d2b](https://github.com/vaam-apps/.github/commit/cdf7d2b745646ecff27b953f4ea813ad8984d340))
* let trivy gate without uploading SARIF ([8231877](https://github.com/vaam-apps/.github/commit/8231877a7e0c3fe1a43a9acc1535a0b0f96cf73f))
* org-wide SAST, linting, Trivy and issue-governance workflows ([7605ffc](https://github.com/vaam-apps/.github/commit/7605ffcec818b8d1e1e0bc376d88e4a5a4547350))
* pass ignore files to Trivy explicitly ([24fa3b0](https://github.com/vaam-apps/.github/commit/24fa3b0c0e611ede4ccfa718d8838d1617e30b11))


### Bug Fixes

* check out the merge ref super-linter needs, replay fixes onto the head ([6dac296](https://github.com/vaam-apps/.github/commit/6dac29680312844fde46ce78d24e50d784147fac))
* clear the failure comment when an issue starts conforming ([1a919e2](https://github.com/vaam-apps/.github/commit/1a919e287fd8652c51bb4c05cf3dd1bbf93afa76))
* **lint:** stop MD024 failing every release-please changelog ([#8](https://github.com/vaam-apps/.github/issues/8)) ([b04a3ff](https://github.com/vaam-apps/.github/commit/b04a3ff5fd9334005b6cd9f14ac55bc1ae7f2879))
* mint the App token with client-id, and let shfmt actually run ([16f86a4](https://github.com/vaam-apps/.github/commit/16f86a4599c48b3467ffdca94a12e34b3be457e3))
* only commit when there is a tracked change to commit ([c3c6bc3](https://github.com/vaam-apps/.github/commit/c3c6bc37dd19da0fbb592831675396e81ee10d6c))
* stop blocking on the SARIF processing poll ([5569c8a](https://github.com/vaam-apps/.github/commit/5569c8afc228b030a892f310a0f6701cabaaa748))
* upload SARIF as the App via the public endpoint ([d9c2a1b](https://github.com/vaam-apps/.github/commit/d9c2a1bd5600efab1f0183eeb8e412595a8c5510))


### Refactoring

* upload SARIF with GITHUB_TOKEN, not the org App ([2278bc3](https://github.com/vaam-apps/.github/commit/2278bc305ca16d1b6bdc8b92c7acbb0d3c450269))


### Documentation

* **adr:** propose an SSDLC and CPSA strategy for the org ([#5](https://github.com/vaam-apps/.github/issues/5)) ([d673060](https://github.com/vaam-apps/.github/commit/d673060ae00119379250a8b0406dfb7e0d59658f))
* architecture docs as preferred source of truth, plus SSDLC control map ([#1](https://github.com/vaam-apps/.github/issues/1)) ([54af9a3](https://github.com/vaam-apps/.github/commit/54af9a3f9caa82cbb0f0ed7c41cf6bd8d8f3fe2c))
* **governance:** one source of truth for the mandatory arc42 sections ([#6](https://github.com/vaam-apps/.github/issues/6)) ([57da409](https://github.com/vaam-apps/.github/commit/57da4093ecd2c50f1da0a98fe88c6e3229c91547))
* how releases work org-wide, and the ten ways they have failed silently ([#9](https://github.com/vaam-apps/.github/issues/9)) ([38266fa](https://github.com/vaam-apps/.github/commit/38266fa62fe2c384aa68f3a9575d83e32263cd5b))
* **releasing:** internal path dependencies, and when NOT to use release-type dart ([e26463f](https://github.com/vaam-apps/.github/commit/e26463f8614076021f2d63d70172ddcece227950))
* **releasing:** PR_TITLE only governs squash, and the skills repos are a deliberate exception ([187fa65](https://github.com/vaam-apps/.github/commit/187fa6510514c29d3a904fb543d126844c9648d2))
* **releasing:** squash-only is now set org-wide; record the canonical shape ([8fd63e6](https://github.com/vaam-apps/.github/commit/8fd63e601febe43697aee39410b13c7c9a4f9948))
* **releasing:** ten repos, not nine — the private one was missed ([ba8bfa3](https://github.com/vaam-apps/.github/commit/ba8bfa37128a1fb90d45a4e183d01e5eb937d6b7))
* **releasing:** token scoping, the changed-files lint gap, and Dart build numbers ([8a70317](https://github.com/vaam-apps/.github/commit/8a703177728e943d50a5220872b9ca17c9131987))


### Continuous Integration

* adopt release-please for this repo's own changelog and tag ([#10](https://github.com/vaam-apps/.github/issues/10)) ([310ee37](https://github.com/vaam-apps/.github/commit/310ee3724295b81a908cb80c7048f8c35cf38c64))


### Chores

* A/B the SARIF upload with both tokens in one run ([ef716fb](https://github.com/vaam-apps/.github/commit/ef716fb386bc7d9eda82436b61d4cb960d4cb8c9))
* probe the Actions permission, stop super-linter commenting ([ab3bbe0](https://github.com/vaam-apps/.github/commit/ab3bbe02c2fd3919a84b62400b87a9695c33ac0a))
* probe what the App token can reach, drop the YAML prettier fix ([2a95142](https://github.com/vaam-apps/.github/commit/2a951425fcf04f3f4b00661b45bc517a5db027a7))
