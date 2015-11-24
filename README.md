# semver-cmp
Compare Semantic Versioning strings in major.minor.patch-pre.release format per SemVer 2.0.0 spec (http://semver.org/spec/v2.0.0.html)

# Usage
Copy the semver-cmp.js file into your project and require it (CommonJS-only for now).

All comparison methods compare versions left to right (first argument against second).

Methods available: gte, lt, cmp, cmppre, split
```
semverCmp = require("semver-cmp");

// Greater than or equal to
semverCmp.gte("1.11.1", "1.9.2"); // true
semverCmp.gte("2.0.0", "2.0.0"); // true
semverCmp.gte("2.0.0", "2.0.0-rc.3"); // true

// Less than
semverCmp.lt("3.1.1", "4.2.2"); // true

// Use numbers (major and minor version comparison only)
semverCmp.lt("1.11.1", 1.12); // true
semverCmp.lt("1.11.1", 2); // true

// Use cmp method
semverCmp.cmp("1.11.1", "2.0.0"); // -1
semverCmp.cmp("2.0.0", "2.0.0"); // 0
semverCmp.cmp("2.3.4", "2.0.0"); // 1

// Use numbers (major and minor version comparison only)
semverCmp.lt("1.11.1", 1.12); // true
semverCmp.gte(2, "1.11.1"); // true
semverCmp.cmp("2.3.4", 5); // -1

// cmppre method compares pre-release strings
semverCmp.cmppre("rc.1", "rc.1"); // 0
semverCmp.cmppre("beta.2", "beta.11"); // -1
semverCmp.cmppre("beta", "alpha"); // 1
semverCmp.cmppre("rc.23.beta", "rc.23"); // 1
semverCmp.cmppre("rc.1+20151204", "rc.1+20151203"); // 0 (+meta info ignored)

// Use split method to extract major, minor, patch, pre-release
// identifiers from version string
// Major, minor, and patch are converted to integers
// Pre-release identifiers remains string
semverCmp.split("1.11.0-rc.1"); // [ 1, 11, 0, "rc.1" ]
```

## License
Open source ISC License
