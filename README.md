<h1 align="center">
  SUNWISE ☀️
  <br>
</h1>

<div align="center">
  <p align="center">
    IOS-BASED MOBILE APPLICATION REGARDING THE NEEDS OF THE SUN EXPOSURE FOR PEOPLE WORKING INDOORS
    <br />
  </p>
</div>

## Key Features

will be added soon

Example
- Scan your contact to detect fraud
- Search contact with phone number
- Search contact with social media information
- Search contact with bank account information (Local bank)
- Report a contact as a fraud

## Library

This repository is packed with:
-   Swift 5.7.1
-   Ruby 
-   Cocoapods 1.11.3

## Getting Started

### 1. Install dependencies

We use cocoapods to manage our package manager dependencies

### 2. Change Working directories to Xcode Project and initialize pod

- pod init

### 3. Install pod depedency

-pod install

### 4. cocoa pods conflict intergration
Option 1:
- pod deintegrate
- pod install

OR

Option 2:
- pod deintegrate
- arch -x86_64 pod install

Open the xcode .xcworkspace project

### 5. Branch Naming Rules
> **IMPORTANT:**  
> - TERKONEKSI dengan JIRA maka gunakan format branch seperti format yang diberikan pada JIRA
> - CONTOH NAMING RULES dari JIRA

- SUNWISE-xx-lorem-ipsum-dolor-amit
- SUNWISE-xx-SUNWISE-yy-SUNWISE-zz-lorem-ipsum

### 6. Pull Request Title Naming Rules
> **IMPORTANT:**  
> - Agar Terintegrasi dengan JIRA maka gunakan format penamaan pull request seperti contoh dibawah
> - Jika ingin menyelesaikan lebih dari 1 backlog di jira bisa dengan contoh urutan kedua dibawah
> - Gunakan Squash & Merge dan mengganti commit sesuai aturan conventional commit pada poin #3 di README
> - Tambahkan "DRAFT: " didepan naming PR jika PR tidak ingin dimerge terlebih dahulu

- SUNWISE-xx "lorem ipsum"
- SUNWISE-xx SUNWISE-yy SUNWISE-zz "lorem ipsum"
- DRAFT: SUNWISE-xx "lorem ipsum"

### 7. Variable naming case convention
- `camelCase` for variable and function declaration


### 8. Commit Message Convention

This repository follows [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/)
#### Format
`<type>(optional scope): <description>`
Contoh: `feat(dashboard): add button`

#### Type:

Type yang bisa digunakan adalah:

- feat → Kalo ada penambahan/pengurangan codingan
- fix → kalo ada bug fixing
- BREAKING CHANGE → kalo ada perubahan yang signifikan (contoh: ubah login flow)
- docs → update documentation (README.md)
- styling → update styling, ga ngubah logic sama sekali (reorder import, benerin whitespace, format code, **NOTE: Perubahan Storyboard / Tampilan tidak menggunakan commit type styling**)
- ci → update github workflow
- test → update testing
- perf → fix sesuatu yang bersifat cuma untuk performance issue (derived state, memo)
- chore → untuk melakukan perubahan misc. selain fitur seperti update depedencies, environment, snippet vs, dll.

#### Optional Scope:

Contoh labeling per page `feat(dashboard): add button`

*kalo gaada scopenya, gausa ditulis.


#### Description:

Description harus bisa mendeskripsikan apa yang dikerjakan. Jika ada beberapa hal yang dikerjakan, maka lakukan commit secara bertahap.

- Setelah titik dua, ada spasi. Contoh: `feat: add something`
- Kalo type `fix` langsung sebut aja issuenya apa. Contoh:  `fix: file size limiter not working`
- Gunakan kata imperative, present tense: "change" bukan "changed" atau "changes"
- Gunakan huruf kecil di semua description. Jangan berikan huruf besar di depan kalimat
- Jangan tambahkan titik di akhir description

## Contributing Git Convention 💬

This website follows [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/urayfajri"><img src="https://avatars.githubusercontent.com/u/77041388?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Uray Muhamad Noor Fajri Widiansyah</b></sub></a><br /><a href="https://github.com/urayfajri/Sunwise?commits?author=urayfajri" title="Code">💻</a></td>
     <td align="center"><a href="https://github.com/urayfajri"><img src="https://avatars.githubusercontent.com/u/77041388?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Ariel Waraney Manueke</b></sub></a><br /><a href="https://github.com/urayfajri/Sunwise?commits?author=urayfajri" title="Code">💻</a></td>
 </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
