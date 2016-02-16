# asp.js File System module

## Quick Example

```asp
<!--#INCLUDE VIRTUAL="/aspjs_modules/fs/index.asp"-->
<%

var fs = require('fs');

fs.readFile('/test.json', function(err, data) {
	// ... error checks
	
	console.log(data);
});

%>
```

## Documentation

[Node.js File System](https://nodejs.org/api/fs.html)

### Implemented

- fs.readdir(path, callback)
- fs.readdirSync(path)
- fs.readFle(path[, options], callback)
- fs.readFileSync(path[, options])
- fs.stat(path, callback)
- fs.statSync(path)
- fs.writeFile(path, data[, options], callback)
- fs.writeFileSync(path, data[, options])
- fs.unlink(path, callback)
- fs.unlinkSync(path)

<a name="license" />
## License

Copyright (c) 2016 Patrik Simek

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
