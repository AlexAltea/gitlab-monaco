# gitlab-monaco

Dynamic syntax highlighting for custom languages in GitLab CE/EE installations via Monaco hot-patching.

**Simply a proof-of-concept project. Not affiliated with GitLab in any way. Execute at your own risk.**

## Usage

Install [Node](https://nodejs.org/), then run the following commands:

```bash
$ npm install
$ npm start
```

This will open your browser and serve a Monaco editor instance at http://localhost:8080/ with all custom languages listed in [`languages.js`](./languages.js) for demonstration and testing purposes.

## Installation in GitLab

Run the following command:

```bash
$ sudo ./install-gitlab.sh
```

Although both the installer script and GitLab/Monaco perform checks when dealing with languages, there are risks when patching a GitLab installation. All changes are client-side so it is not necessary to restart the GitLab server.

Uninstall the patched languages via:

```bash
$ sudo ./install-gitlab.sh --remove
```
