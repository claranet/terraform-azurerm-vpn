## 8.3.0 (2025-08-01)

### Features

* **AZ-1597:** 🚀 add support for private IP address in VPN Gateway 7287a3c

### Bug Fixes

* **AZ-1593:** 🐛 improve validation for active-active configuration 2e551c8

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review b0cf314
* 🗑️ remove old commitlint configuration files 7b15c7b
* **AZ-1593:** apply suggestions e2a8125
* **deps:** update dependency opentofu to v1.10.0 b60906b
* **deps:** update dependency opentofu to v1.10.1 6c4be3c
* **deps:** update dependency opentofu to v1.10.3 4aab015
* **deps:** update dependency tflint to v0.58.0 b7bd774
* **deps:** update dependency tflint to v0.58.1 3d0d6ba
* **deps:** update dependency trivy to v0.63.0 a04d7e0
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 798ea89
* **deps:** update tools 662c69d

## 8.2.0 (2025-05-23)

### Features

* **AZ-1559:** 🚀 add BGP settings support for VPN connections 1c19e79

### Bug Fixes

* **AZ-1556:** 🐛 add validation for active-active configuration 859ca9a
* **AZ-1559:** 🐛 correct type for `secondary` BGP address to required 74ec1b6

### Miscellaneous Chores

* **AZ-1556:** 🔧 update Terraform minimum version to 1.9 4b7d27a
* **deps:** update dependency opentofu to v1.9.1 f1c060b
* **deps:** update dependency tflint to v0.57.0 eedf5f2
* **deps:** update dependency trivy to v0.61.1 1a2bf9a
* **deps:** update dependency trivy to v0.62.0 bcbd7e1
* **deps:** update dependency trivy to v0.62.1 04aba6a

## 8.1.1 (2025-04-11)

### Bug Fixes

* use Entra vars naming 2329d0d

### Miscellaneous Chores

* **deps:** update dependency pre-commit to v4.2.0 f4e6f8e
* **deps:** update dependency terraform-docs to v0.20.0 7076ca9
* **deps:** update dependency trivy to v0.59.1 840f4c5
* **deps:** update dependency trivy to v0.60.0 1ccc564
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 1175492
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 1f7fda0
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 c1ad2d4
* **deps:** update tools 79f2523
* **deps:** update tools 077e6bd
* update Github templates 911f3eb

## 8.1.0 (2025-01-24)

### Features

* **AZ-1502:** support nat rules creation 33b2952

### Bug Fixes

* **AZ-1492:** `ipconfig_custom_names` not taken into account 9d9c840
* **AZ-1502:** fix validation regex c3310c4

### Miscellaneous Chores

* **AZ-1088:** apply suggestions 9ff4d0b
* **deps:** update dependency opentofu to v1.8.8 e972cd0
* **deps:** update dependency opentofu to v1.9.0 3223db9
* **deps:** update dependency pre-commit to v4.1.0 9d4f0c5
* **deps:** update dependency tflint to v0.55.0 fbdeeca
* **deps:** update dependency trivy to v0.58.1 a2c85b4
* **deps:** update dependency trivy to v0.58.2 0cf882f
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 3ef6637
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 6708e91
* **deps:** update tools 49f9b36
* update tflint config for v0.55.0 9fcb399

## 8.0.1 (2024-11-27)

### Bug Fixes

* **AZ-1088:** default empty list for `additional_routes_to_advertise` variable 72a4d86
* **AZ-1088:** default Public IP SKU should be `Standard` 1f90716
* **AZ-1088:** public IP allocation method should be `Static` by default 4712182

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.6 fa09970

## 8.0.0 (2024-11-22)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** module v8 structure and updates 2197142

### Code Refactoring

* **AZ-1088:** apply suggestion(s) to file(s) 831c182

### Miscellaneous Chores

* **deps:** update dependency claranet/diagnostic-settings/azurerm to v7 5cc4386
* **deps:** update dependency claranet/diagnostic-settings/azurerm to v8 fb05d91
* **deps:** update dependency claranet/subnet/azurerm to v7.2.0 47d8ec8
* **deps:** update dependency claranet/subnet/azurerm to v8 84b1063
* **deps:** update dependency opentofu to v1.8.3 becdbcf
* **deps:** update dependency opentofu to v1.8.4 3019e5d
* **deps:** update dependency pre-commit to v4 804c890
* **deps:** update dependency pre-commit to v4.0.1 33d49d3
* **deps:** update dependency tflint to v0.54.0 35fe819
* **deps:** update dependency trivy to v0.56.1 4a4082f
* **deps:** update dependency trivy to v0.56.2 2e47817
* **deps:** update dependency trivy to v0.57.1 0e5bf6f
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 f9ed987
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 438a447
* **deps:** update tools 3b0ffd1
* prepare for new examples structure b3de996
* update examples structure c73c0c9

## 7.6.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider fec4add

## 7.5.1 (2024-10-01)

### Documentation

* update README badge to use OpenTofu registry fe27f03

### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 1a30687
* **AZ-1391:** update semantic-release config [skip ci] 5344ba3

### Miscellaneous Chores

* bump minimum AzureRM version 08cf0ff
* **deps:** add renovate.json b1179a6
* **deps:** enable automerge on renovate 89068c5
* **deps:** update dependency claranet/subnet/azurerm to v7.1.0 f241577
* **deps:** update dependency opentofu to v1.7.0 aece048
* **deps:** update dependency opentofu to v1.7.1 2c61e9f
* **deps:** update dependency opentofu to v1.7.2 f1435a9
* **deps:** update dependency opentofu to v1.7.3 c17d9f2
* **deps:** update dependency opentofu to v1.8.1 199ca36
* **deps:** update dependency opentofu to v1.8.2 94e9338
* **deps:** update dependency pre-commit to v3.7.1 74d3b14
* **deps:** update dependency pre-commit to v3.8.0 a61aaf7
* **deps:** update dependency terraform-docs to v0.18.0 c2f586f
* **deps:** update dependency terraform-docs to v0.19.0 37b128e
* **deps:** update dependency tflint to v0.51.0 74912f0
* **deps:** update dependency tflint to v0.51.1 001a374
* **deps:** update dependency tflint to v0.51.2 adb2a63
* **deps:** update dependency tflint to v0.52.0 7caa052
* **deps:** update dependency tflint to v0.53.0 2857113
* **deps:** update dependency trivy to v0.50.2 08cce7e
* **deps:** update dependency trivy to v0.50.4 f8c0737
* **deps:** update dependency trivy to v0.51.0 2ea5fec
* **deps:** update dependency trivy to v0.51.1 91547c8
* **deps:** update dependency trivy to v0.51.2 c9ca816
* **deps:** update dependency trivy to v0.51.4 8fec09d
* **deps:** update dependency trivy to v0.52.0 1fe67a5
* **deps:** update dependency trivy to v0.52.1 b6f0561
* **deps:** update dependency trivy to v0.52.2 0597266
* **deps:** update dependency trivy to v0.53.0 f1f10c4
* **deps:** update dependency trivy to v0.54.1 645d8cd
* **deps:** update dependency trivy to v0.55.0 6aad767
* **deps:** update dependency trivy to v0.55.1 1cc6684
* **deps:** update dependency trivy to v0.55.2 46f75a6
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 3b8aff7
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 8b285fe
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 f22e778
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 cc96d10
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 1422c01
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 f7355e2
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 fbe6456
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 20402d6
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 15144e7
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 bccf2ec
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 a9eba1d
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 835f693
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 ba51673
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 69175cf
* **deps:** update renovate.json e36f688
* **deps:** update terraform claranet/diagnostic-settings/azurerm to ~> 6.5.0 0599551
* **deps:** update terraform claranet/subnet/azurerm to v6.3.0 0c6877d
* **deps:** update terraform claranet/subnet/azurerm to v7 3032887
* **deps:** update tools 5ea7389
* **pre-commit:** update commitlint hook b13a3d8
* **release:** remove legacy `VERSION` file 35a1b36

# v7.5.0 - 2023-10-27

Breaking
  * AZ-1134: Rework vpn_gw_pulic_ip_custom_name

Changed
  * AZ-1150: Add Conditionnal share key generation
  * AZ-1146: Add support for multiple root certificates

# v7.4.0 - 2023-02-24

Added
  * AZ-1010: Add diagnostic-settings configuration

# v7.3.0 - 2023-02-20

Added
  * [GH-2](https://github.com/claranet/terraform-azurerm-vpn/pull/2): Add certificate authentication capability
  * AZ-1009: Add some missing `vpn_connections` related parameters

# v7.2.1 - 2022-12-14

Fixed
  * AZ-908: Bump subnet module to v6.1.0

# v7.2.0 - 2022-11-24

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v7.1.0 - 2022-11-04

Added
  * [GH-1](https://github.com/claranet/terraform-azurerm-vpn/pull/1): Add P2S VPN client configuration option with AAD enabled

# v7.0.0 - 2022-10-28

Breaking
  * AZ-840: Require Terraform 1.3+
  * AZ-886: Rework module code, minimum AzureRM version to `v3.22`
  * AZ-886: Default VPN is now `Generation2` with `VpnGw2AZ` multi AZ SKU

Added
  * AZ-884: Add NAT rules link options
  * AZ-821: Add zone support for public IPs

# v6.0.0 - 2022-10-21

Changed
  * AZ-844: Bump `subnet` module to latest version

# v5.3.0 - 2022-06-17

Added
  * AZ-771: Allow usage of an existing subnet gateway
  * AZ-774: Add second IP by default for active-active VPN to match requirements

Fixed
  * AZ-771: Add a try function for the subnet gateway output

# v5.2.0 - 2022-05-13

Breaking
  * AZ-666: Option to select which generation of VPN to use
  * AZ-686: Add multi connections and public ips

Changed
  * AZ-666: Upgrade provider to `>= 2.38.0` [#9330](https://github.com/hashicorp/terraform-provider-azurerm/pull/9330)

# v5.1.0 - 2022-04-15

Added
  * AZ-615: Add an option to enable or disable default tags

# v5.0.0 - 2022-01-13

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

# v4.2.0 - 2022-01-12

Breaking
  * AZ-651: Change `on_prem_gateway_ip` parameter with a more generic one: `on_prem_gateway_endpoint` (which can be an IP or a FQDN)
  * AZ-651: Upgrade AzureRM provider minimum version to `v2.34.0`

Changed
  * AZ-572: Revamp examples and improve CI

# v4.1.0/v3.2.0 - 2021-08-24

Updated
  * AZ-495: Compatible with terraform `v0.15+/v1.0+`, README update
  * AZ-530: Module cleanup, linter errors fix
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v3.1.0/v4.0.0 - 2021-02-26

Updated
  * AZ-273: Module now compatible terraform `v0.13+` and `v0.14+`

# v3.0.0 - 2020-07-09

Breaking
  * AZ-198: Upgrade module to Azurerm 2.x

Changed
  * AZ-209: Update CI with Gitlab template

# v2.0.0 - 2020-02-05

Breaking
  * AZ-94: Upgrade module to terraform v0.12

Added
  * AZ-118: Add NOTICE and LICENSE file + update README with badges
  * AZ-119: Revamp to match Terraform/Hashicorp best practices
  * AZ-175: Public release + Fix bug when using dedicated RG

# v0.1.1 - 2019-08-23

Updated
  * AZ-91: Allow custom name for GW IP tf resource

# v0.1.0 - 2019-07-19

Added
  * AZ-91: First version
