# HackTheU Registration

**Powerful and extensible registration system for hackathons and other large events**

[Check it out running in production](https://registration.hacktheu.org) for HackTheU 2019!

This is HackTheU's fork of HackGT's Registration Solution.

## Features

- Seamless OAuth and local signup logins with automatic email verification via [HackGT Ground Truth](https://github.com/HackGT/ground-truth)
	- Get users up and running quickly with GitHub, Google, and Facebook OAuth or Georgia Tech CAS logins right out of the box
	- Full support for local logins as well if users prefer
- Users can easily register (and confirm their attendance if accepted) and choose which "branch" they want to complete (e.g. partipant, mentor, volunteer) all from a single location
- Users can create or join a team any time before or after completing registration. Admins can configure the maximum team size (defaults to 4).
- For admins, the admin panel contains options for managing all aspects of registration including:
	- Statistics about the user of sign ups, registrations, acceptances, and confirmations
	- Graphs displaying aggregated registration data
	- List of all users in a table including name, email, admin status, and application status, and log in method
	- List of all applicants with application responses and accept / unaccept button sortable by application branch and accepted status
	- Acceptance emails are sent out only when a send acceptance emails button is clicked allowing for decisions to be reviewed before being finalized
	- Setting application and confirmation open and close times as well as what question branches from `questions.json` are for applications, confirmations, or hidden
	- Full email customization using a built-in HTML / Markdown editor with live preview and variable interpolation
	- Ability to view settings from `config.json` or environment variables that cannot be changed while the app is running

***

- Fully configurable and customizable without touching any code
	- Question structure is defined in [`questions.json`](server/config/questions.json) and loaded dynamically without having to edit *any* HTML or JS code
		- Text, phone number, date, URL, and file inputs, checkboxes, radio buttons, select dropdowns, and textareas are all supported
		- Common attributes like placeholders, "other" options, and required questions are supported
		- Text blocks can be attached to questions and stacked. Custom footer text above the submit button is also supported.
		- Works with an unlimited number of questions sets (known as branches) when applying and confirming (e.g. HackGT 4 has participant, mentor, and volunteer applications)
	- Support for custom storage engines for file uploads
		- Comes with disk (default) and Amazon S3 storage engines
	- Email content can be written in HTML or Markdown directly from the admin panel with live previews for the generated HTML and text-only emails
		- Custom email styles are also fully supported
		- Variable interpolation is available for details like user's name, user's email, user's team name, event name, application branch, and confirmation branch.
	- Themes can be configured by editing [`theme.css`](client/css/theme.css) (full theming engine planned)

## Building and running

First, make sure that you have a MongoDB server up and running and a recent version of Node.js installed. Once your `config.json` or environment variables are set, you can be up and running in less than 30 seconds:

To build and run the server:

	# Install dependencies
	npm install
	# Build question type definitions for TypeScript from the questions schema and compile
	npm run build
	# Run server (check the logs for the port and any warning information)
	npm start

Visit `http://localhost:3000` and you're good to go!

## Deployment

A [Dockerfile](Dockerfile) is provided for convenience.

Configuration should normally be done by editing the `server/config/config.json` file. Environment variables take precedence over `config.json` and should be used when those options need to be overridden or `config.json` can't be used for some reason (e.g. certain deployment scenarios).

Environment Variable | Description
---------------------|------------
PRODUCTION | Set to `true` to enable reverse proxy trusting (default: `false`)
PORT | The port the check in system should run on (default: `3000`)
MONGO_URL | The URL to the MongoDB server (default: `mongodb://localhost/registration`)
VERSION_HASH | The Git short hash used to identify the current commit (default: parsed automatically from the `.git` folder, if it exists)
ADMIN_KEY_SECRET | An API key used to authenticate as admin an access the GraphQL api (default: random key that changes every server restart)
COOKIE_MAX_AGE | The `maxAge` of cookies set in milliseconds (default: 6 months) **NOTE: this is different from the session TTL**
COOKIE_SECURE_ONLY | Whether session cookies should sent exclusively over secure connections (default: `false`)
PASSWORD_RESET_EXPIRATION | The time that password reset links sent via email should be valid for in milliseconds (default: 1 hour)
SESSION_SECRET | The secret used to sign and validate session cookies (default: random 32 bytes regenerated on every start up)
GROUND_TRUTH_URL | Base URL of [Ground Truth](https://github.com/HackGT/ground-truth) instance (e.g. `https://login.hack.gt`) *required*
GROUND_TRUTH_ID | OAuth client ID from Ground Truth *required*
GROUND_TRUTH_SECRET | OAuth client secret from Ground Truth *required*
EMAIL_FROM | The `From` header for sent emails (default: `HackGT Team <hello@hackgt.com>`)
EMAIL_KEY | The SendGrid API key for sending emails (default: *none*) *required*
ADMIN_EMAILS | A JSON array of the emails of the users that you want promoted to admin status when they create their account (default: none)
EVENT_NAME | The current event's name which affects rendered templates and sent emails (default: `Untitled Event`)
STORAGE_ENGINE | The name of the storage engine that handles file uploads as defined in [storage.ts](server/storage.ts) (default: `disk`)
STORAGE_ENGINE_OPTIONS | JSON-encoded object containing options to be passed to the storage engine. Must at least contain a value for the `uploadDirectory` key. For the default `disk` storage engine, this directory is relative to the app's root, can be absolute, and will be created if it doesn't exist. (default: `{ "uploadDirectory": "uploads" }`)
DEFAULT_TIMEZONE | Timezone used for dates and times (default: `America/New_York`)
MAX_TEAM_SIZE | The maximum number of users allowed per team (default: `4`)
QUESTIONS_FILE | Specify a path for the `questions.json` file. (default: ./server/config/questions.json)
THEME_FILE | Specify a path for the `theme.css` file, which will be loaded last at every page.
FAVICON_FILE | Path to the favicon file (default is no favicon).
FAVICON_FILE_BASE64 | Same as `FAVICON_FILE_BASE64` but the file is base64 encoded.


## Contributing

If you happen to find a bug or have a feature you'd like to see implemented, please [file an issue](https://github.com/HackGT/registration/issues).

If you have some time and want to help us out with development, thank you! You can get started by taking a look at the open issues, particularly the ones marked [help wanted](https://github.com/HackGT/registration/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) or [good first issue](https://github.com/HackGT/registration/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22). Feel free to ask questions to clarify things, determine the best way to implement a new feature or bug fix, or anything else!

### Tips

- Please try your best to follow the existing coding styles and conventions.
- Use the latest version of TypeScript
- Use TypeScript's [type annotations](http://www.typescriptlang.org/docs/handbook/basic-types.html) whenever possible and Promises for asynchronous operations in conjunction with ES7 async/await (TypeScript's transpilation allows for the use of these features even on platforms that don't support or entirely support ES6 and ES7).
- We also have [TSLint](https://palantir.github.io/tslint/) [config](tslint.json) to catch *most* style errors or inconsistencies. Sometimes, however, it's necessary to break these rules to get something to work. First, consider if there might be a better way of tackling the problem so that disabling TSLint isn't required. Only if there isn't should you [disable TSLint](https://palantir.github.io/tslint/usage/rule-flags/) on a line or section basis. *Never disable for entire files.*
- Don't overuse TypeScript's [non-null assertion operator](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-0.html#non-null-assertion-operator) (the `!` after expressions). A value being `null` is something you should check for and not simply disregard. The preferred way to deal with possibly `null` values is to check with `if (value) {}` and fail gracefully if it is not truthy. The TypeScript compiler is usually smart enough to know when you do this, but in more complex cases, an object already checked for non-`null` status will be reported as possibly null. In this case, you should use the non-null assertion operator.
- **Make sure your branch builds without warnings or errors (including those from TSLint) before committing.** Automatic builds are set up with Travis CI and will be marked failed if your code doesn't compile.
- **Use descriptive commit messages that begin with an imperative verb, are properly capitalized, spelled correctly, descriptive, and do not exceed 72 characters.** For commits with additional detail, include this in the description and not the main message (you can do this by running `git commit` with no flags and entering your title, two new lines, and then your description). Descriptions can be as long as necessary.

## License

Copyright &copy; 2019 HackGT. Released under the MIT license. See [LICENSE](LICENSE) for more information.
