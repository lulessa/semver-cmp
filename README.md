# semver-cmp
Compare Semantic Versioning strings in major.minor.patch-pre.release format compliant with SemVer 2.0.0 spec (http://semver.org/spec/v2.0.0.html)

# Usage
Copy the semver-cmp.js file into your project and require it (CommonJS-only for now).

All comparison methods compare versions left to right (first argument against second).

Methods available: `gte`, `lt`, `cmp`, `cmppre`, `split`

## Basic Usage
```js
semverCmp = require("semver-cmp");

// Greater than or equal to
semverCmp.gte("1.11.1", "1.9.2"); // true
semverCmp.gte("2.0.0", "2.0.0"); // true
semverCmp.gte("2.0.0", "2.0.0-rc.3"); // true

// Less than
semverCmp.lt("3.1.1", "3.1.2"); // true
semverCmp.gte("2.0.0-rc.3", "2.0.0"); // true
```

The Base `cmp` method is internally used by `gte` and `lt` and also available directly. 
```js
semverCmp.cmp("1.11.1", "2.0.0"); // -1 (Left < Right)
semverCmp.cmp("2.0.0", "2.0.0"); // 0 (Equal)
semverCmp.cmp("2.3.4", "2.0.0"); // 1 (Left > Right)
```

You may use an integer for major version comparison or number with decimals for major and minor version comparison. Numbers will be converted to strings. Ommitted patch or minor.patch identifiers are treated as zeroes.
```js
semverCmp.lt("1.11.1", 1.12); // true
semverCmp.gte("1.11.1", 2); // false
semverCmp.cmp("2.3.4", 5); // -1
semverCmp.cmp("2.0.0", 2); // 0
```

Use the `cmppre` method to compare pre-release strings by themselves.
```js
semverCmp.cmppre("rc.1", "rc.1"); // 0
semverCmp.cmppre("beta.2", "beta.11"); // -1
semverCmp.cmppre("beta", "alpha"); // 1
semverCmp.cmppre("rc.23.beta", "rc.23"); // 1
semverCmp.cmppre("rc.1+20151204", "rc.1+20151203"); // 0 (+meta info ignored)
```

The `split` method extracts an array of identifiers from a version string. Major, minor, and patch are converted to integers. Pre-release identifiers (if any) remain as one string.
```js
semverCmp.split("1.11.0-rc.1"); // [ 1, 11, 0, "rc.1" ]
semverCmp.split("1.11.0"); // [ 1, 11, 0 ]
semverCmp.split(1.11); // [ 1, 11, 0 ]
semverCmp.split(2); // [ 2, 0, 0 ]
```

#Contributing

* Fork the repo
* In your console, run `npm install`
* After making changes, make sure tests still pass. Run `npm test` to compile the coffeescript files and run tests.
* Open a pull request on github

The above assumes you have coffee-script installed. You can install it globablly with `npm install -g coffee-script`

##ISC License (ISC)
Copyright (c) 2015 Lucas Lessa
https://github.com/lulessa/semver-cmp

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
