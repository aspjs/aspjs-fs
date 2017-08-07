<%

define('fs', function(require, exports, module) {
	module.exports = {
		readdir: function readdir(path, done) {
			var error, files;
			
			try {
				files = this.readdirSync(path);
			} catch (ex) {
				ex.stack = Error.captureStackTrace();
				error = ex;
			};
			
			done(error, files);
			
			return this;
		},
		readdirSync: function readdirSync(path) {
			if (path.substr(0, 1) === '/') path = Server.mapPath(path);
			
			var list = [], fso = Server.CreateObject("Scripting.FileSystemObject");
			
			try {
				var dir = fso.GetFolder(path);
	
				var e = new Enumerator(dir.SubFolders);
				while (!e.atEnd()) {
					list.push(e.item().name);
					e.moveNext();
				};
	
				e = new Enumerator(dir.Files);
				while (!e.atEnd()) {
					list.push(e.item().name);
					e.moveNext();
				};
			} catch (ex) {
				ex.stack = ex.stack || Error.captureStackTrace();
				throw ex;
			};
	
			return list;
		},
		readFile: function readFile(path, options, done) {
			if ('function' === typeof options) {
				done = options;
				options = null;
			};
			
			var error, data;
			
			try {
				data = this.readFileSync(path, options);
			} catch (ex) {
				ex.stack = Error.captureStackTrace();
				error = ex;
			};
			
			done(error, data);
			
			return this;
		},
		readFileSync: function readFileSync(path, options) {
			if (!path) {
				var err = new Error("File path is missing.");
				err.stack = Error.captureStackTrace();
				throw err;
			};
			
			options = options || {};
			options.encoding = options.encoding || 'binary';
			if (options.encoding === 'utf8') options.encoding = 'utf-8' // adodb.stream requires utf-8 format
			
			if (path.substr(0, 1) === '/') path = Server.mapPath(path);
			
			try {
				var res, stream = Server.CreateObject("ADODB.Stream");
				if (options.encoding === 'binary') {
					stream.type = adTypeBinary;
					stream.open();
					stream.loadFromFile(path);
					res = new Buffer(stream.read(adReadAll));
				} else {
					stream.type = adTypeText;
					stream.charSet = options.encoding;
					stream.open();
					stream.loadFromFile(path);
					res = stream.readText(adReadAll);
				};
				stream.close();
				return res;
			} catch (ex) {
				ex.stack = ex.stack || Error.captureStackTrace();
				throw ex;
			};
			
			return this;
		},
		stat: function stat(path, done) {
			var error, info;
			
			try {
				info = this.statSync(path);
			} catch (ex) {
				ex.stack = Error.captureStackTrace();
				error = ex;
			};
			
			done(error, info);
			
			return this;
		},
		statSync: function statSync(path) {
			if (path.substr(0, 1) === '/') path = Server.mapPath(path);
			
			var info, fso = Server.CreateObject("Scripting.FileSystemObject");
			
			try {
				if (fso.fileExists(path)) {
					var file = fso.GetFile(path);
					info = {
						isFile: function isFile() { return true; },
						isDirectory: function isFile() { return false; },
						size: file.size,
						atime: new Date(file.DateLastAccessed),
						mtime: new Date(file.DateLastModified),
						birthtime: new Date(file.DateCreated)
					};
				} else if (fso.folderExists(path)) {
					info = {
						isFile: function isFile() { return false; },
						isDirectory: function isFile() { return true; }
					};
				} else {
					throw new Error("File not found.");
				}
			} catch (ex) {
				ex.stack = ex.stack || Error.captureStackTrace();
				throw ex;
			};
	
			return info;
		},
		writeFile: function writeFile(path, data, options, done) {
			if ('function' === typeof options) {
				done = options;
				options = null;
			};
			
			var error;
			
			try {
				this.writeFileSync(path, data, options);
			} catch (ex) {
				ex.stack = Error.captureStackTrace();
				error = ex;
			};
			
			done(error);
			
			return this;
		},
		writeFileSync: function writeFileSync(path, data, options) {
			if (!path) {
				var err = new Error("File path is missing.");
				err.stack = Error.captureStackTrace();
				throw err;
			};
			
			options = options || {};
			options.encoding = Buffer.isBuffer(data) ? 'binary' : (options.encoding || 'utf8');
			if (options.encoding === 'utf8') options.encoding = 'utf-8'; // adodb.stream requires utf-8 format
			
			if (options.encoding === 'binary' && !Buffer.isBuffer(data)) {
				var err = new Error("Buffer expected.");
				err.stack = Error.captureStackTrace();
				throw err;
			};
			
			if (path.substr(0, 1) === '/') path = Server.mapPath(path);
			
			try {
				var res, stream = Server.CreateObject("ADODB.Stream");
				if (options.encoding === 'binary') {
					stream.type = adTypeBinary;
					stream.open();
					stream.write(data._buffer);
				} else {
					stream.type = adTypeText;
					stream.charSet = options.encoding;
					stream.open();
					stream.writeText(data);
				};
				stream.saveToFile(path, adSaveCreateOverWrite);
				stream.close();
				return res;
			} catch (ex) {
				ex.stack = ex.stack || Error.captureStackTrace();
				throw ex;
			};
			
			return this;
		},
		unlink: function unlink(path, done) {
			var error;
			
			try {
				this.unlinkSync(path);
			} catch (ex) {
				ex.stack = Error.captureStackTrace();
				error = ex;
			};
			
			done(error);
			
			return this;
		},
		unlinkSync: function unlinkSync(path) {
			if (path.substr(0, 1) === '/') path = Server.mapPath(path);
			
			var fso = Server.CreateObject("Scripting.FileSystemObject");
			
			try {
				if (fso.fileExists(path)) {
					fso.deleteFile(path);
				} else if (fso.folderExists(path)) {
					fso.deleteFolder(path);
				} else {
					throw new Error("File not found.");
				}
			} catch (ex) {
				ex.stack = ex.stack || Error.captureStackTrace();
				throw ex;
			};
	
			return this;
		}
	};
});

%>
