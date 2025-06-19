## [1.0.2](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/compare/v1.0.1...v1.0.2) (2025-06-19)


### Bug Fixes

* Update input descriptions and restructure Terraform action for clarity ([01ea45e](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/01ea45e860bfd96b575760c3150891c4037f3103))

## [1.0.1](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/compare/v1.0.0...v1.0.1) (2025-06-03)


### Bug Fixes

* Refactor inputs for Terraform action to remove DynamoDB table and add release tag ([fff23ef](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/fff23ef72d5ad5304453df0d22f6f69c101c5848))
* Remove unnecessary shell declaration for state key computation step ([5313dd2](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/5313dd2e7026c431ebda65412ef7bf5689ecbd23))
* Rename output ID for backend key computation and update backend configuration to use DynamoDB table ([2cb9075](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/2cb90755318e1c70a34a329daed34b59cee8349f))
* Update input parameter names and restructure Terraform action for clarity ([5099cc7](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/5099cc7cf71c75104a8fb69084ee4147e37744a4))

# 1.0.0 (2025-05-24)


### Bug Fixes

* Correct backend key reference in Terraform init step ([7136db4](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/7136db44bc1b6a3f532d82c4e2baceab1a3d1d9d))
* Correct working directory references in Terraform GitHub Action ([87b6393](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/87b6393f8ea77f0bc9e5ad610059482d8abae8c6))
* Set default value for tf-vars-file and remove debug information from action steps ([f7392ae](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/f7392ae7ebeb2b1a828e74f54a463bb6a4945db0))
* Set working directory for artifact upload step in Terraform action ([cf39313](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/cf39313c959e1c15ca02d741fe33a30b560bfa3f))
* Update artifact upload path to include full path for Terraform plan output ([bcee090](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/bcee090b53e75ce6e2254881422b3f26cec6cefd))
* Update artifact upload path to use relative file names in Terraform action ([70c7ba5](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/70c7ba5f20ac542352e210eee89bf7f3e6c8bc6c))
* Update Terraform plan output handling to separate plan file and summary output ([0b6f168](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/0b6f1689ebc07e5d458df3e7b4e342c80380f977))
* Update Terraform plan output handling to use the correct plan file ([4259a0d](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/4259a0de1aa464fa01d2b5cb8dcfd7725f87befd))


### Features

* Add debug information output to Terraform GitHub Action ([3dd6536](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/3dd6536dec32442eaef5cd2de5fe3c1c6fd40a9b))
* Add working directory output to GitHub Action for Terraform Plan ([a4efd2e](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/a4efd2e21e0d30964ed90c204cdac930ecea49f5))
* Enhance debug output in Terraform GitHub Action to include available files ([750a20e](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/750a20e71367ce3f18fee4358dd66fe7d0ae2213))
* Improve debug output in Terraform GitHub Action to include working directory and TF var file content ([134f1e4](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/134f1e498504c45e757a5d6aad94046765a359a8))
* Initial Release ([40c4146](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/40c41465e878449a13b7c21edcd4d11e948fab2f))
* Update GitHub Action for Terraform Plan with enhanced features and inputs ([666eadf](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/commit/666eadf1f15fd240d5fb5e6943d66b78ff5ca182))

# Changelog

All notable changes to this project will be documented in this file.
