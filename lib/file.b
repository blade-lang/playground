# file() function override for the sandbox runtime
# 
# based on io.BytesIO

import os

class file {
  # trackers
  var _open = true
  var _number = 0
  var _max_length = 0
  var _position = 0
  var _file

  var _source = nil
  var _is_binary = false

  /**
   * Returns a new instance of BytesIO
   * 
   * @param bytes source
   * @param string mode: The I/O open mode - Default is `r`
   * @constructor
   */
  file(path, mode) {
    if !mode mode = 'r'

    if !is_string(path) {
      raise Exception('file must take source from a bytearray')
    } else if !is_string(mode) {
      raise Exception('invalid I/O mode')
    }

    self._mode = mode
    self._path = os.abs_path(path)

    self._max_length = -1
    if self._can_write() {
      if !____FILESYSTEM____.contains(self._path) {
        ____FILESYSTEM____.set(self._path, {
          content: bytes(0),
          ctime: time(),
          mtime: 0,
          atime: 0,
          is_symbolic: false,
          mode: 0c644,
          dev: 0,
          ino: 0,
          nlink: 0,
          uid: 0,
          gid: 0,
          blksize: 4096,
  
          # +3 for stdout, stdin, and stderr
          number: rand(0, ____FILESYSTEM____.length() + 3),
        })
      }

      self._max_length = (
        self._source = (
          self._file = ____FILESYSTEM____.get(self._path)
        ).content
      ).length()
    } else if !os.dir_exists(self._path) and ____FILESYSTEM____.contains(self._path) {
      self._max_length = (
        self._source = (
          self._file = ____FILESYSTEM____.get(self._path)
        ).content
      ).length()
    }

    self._is_binary = mode.index_of('b') > -1
  }

  /**
   * Only true if the file is writable or has content.
   * 
   * @returns bool
   */
  exists() {
    return self._file != nil
  }

  /**
   * Closes the stream to an opened BytesIO. You'll rarely ever 
   * need to call this method yourself in most use cases.
   */
  close() {
    self._do_close()
  }

  /**
   * Opens the stream to a BytesIO for the operation originally 
   * specified on the BytesIO object during creation. 
   * 
   * You may need to call this method after a call to `read()` 
   * if the length isn't specified or `write()` if you wish to 
   * read or write again as the BytesIO will already be closed.
   */
  open() {
    return self._do_open()
  }

  /**
   * Reads the content of an opened BytesIO up to the specified length 
   * and returns it as string or bytes if the BytesIO was opened in the 
   * binary mode. If the length is not specified, the BytesIO will be 
   * read to the end.
   * 
   * This method requires that the BytesIO be opened in the read mode 
   * (default mode) or a mode that supports reading. If you aren't 
   * reading the full length of the BytesIO, you'll need to call the 
   * close() method to free the BytesIO for further reading, otherwise, 
   * the close() method will be automatically called for you.
   * 
   * @param number length: Default = -1
   * @returns bytes
   * @throws Exception
   */
  read(length) {
    if !length {
      length = self._max_length - self._position
    }

    if !is_number(length) {
      raise Exception('length must be a number')
    }

    if !self._open {
      self._do_open()
    }

    var result = self._read(length)
    self._do_close()
    return result
  }

  /**
   * Same as `read()`, but doesn't open or close the BytesIO automatically.
   * 
   * @param number length: Default = -1
   * @returns bytes
   * @throws Exception
   */
  gets(length) {
    if !length {
      length = self._max_length - self._position
    }

    if !is_number(length) {
      raise Exception('length must be a number')
    }

    return self._read(length)
  }

  /**
   * Writes a string or bytes to an opened BytesIO at the current insertion 
   * point. When the BytesIO is opened with the a mode enabled, write will 
   * always start from the end of the BytesIO. 
   * 
   * If the seek() method has been previously called, write will begin 
   * from the seeked position, otherwise it will start at the beginning 
   * of the BytesIO.
   * 
   * @param bytes|string
   * @returns number
   */
  write(data) {
    if !is_bytes(data) and !is_string(data) {
      raise Exception('string or bytes expected')
    }

    if is_string(data) data = data.to_bytes()

    if !self._open {
      self._do_open()
    }

    return self._write(data)
  }

  /**
   * Same as `write()`, but doesn't open or close the BytesIO automatically.
   * 
   * @param bytes|string
   * @returns number
   */
  puts(data) {
    if !is_bytes(data) and !is_string(data) {
      raise Exception('string or bytes expected')
    }

    if is_string(data) data = data.to_bytes()

    return self._write(data)
  }

  /**
   * Returns the integer file descriptor number that is used by the 
   * underlying implementation to request I/O operations from the 
   * operating system. This can be very useful for low-level interfaces 
   * that uses or act as BytesIO descriptors.
   * 
   * @returns number
   */
  number() {
    return self._file ? self._file.number : -1
  }

  /**
   * Always returns `false` as a BytesIO is not a TTY device.
   * 
   * @returns bool
   */
  is_tty() {
    return false
  }

  /**
   * Returns `true` if the BytesIO is open for reading or writing and 
   * `false` otherwise.
   * 
   * @returns bool
   */
  is_open() {
    return self._open
  }

  /**
   * Returns `true` if the BytesIO is closed for reading or writing and 
   * `false` otherwise.
   */
  is_closed() {
    return !self._open
  }

  /**
   * Does nothing for a BytesIO
   */
  flush() {
    # do nothing...
  }

  /**
   * @returns bool
   */
  symlink(path) {
    return false
  }

  /**
   * @returns dict
   */
  stats() {
    if !self._file {
      raise Exception('cannot get stats for non-existing file')
    }

    return {
      is_readable: self._can_read(),
      is_writable: self._can_write(),
      is_executable: self._can_read() and !self._can_write(),
      size: self._source.length(),
      mtime: self._file.mtime,
      atime: self.__file.atime,
      ctime: self.__file.ctime,
      is_symbolic: self._file.is_symbolic,
      mode: self._file.mode,
      dev: self._file.dev,
      ino: self._file.ino,
      nlink: self._file.nlink,
      uid: self._file.uid,
      gid: self._file.gid,
      blksize: self._file.blksize,
      blocks: max(self._source.length() // 4096, 1),
    }
  }

  /**
   * Clears the bytearray and closes it for reading or writing.
   * 
   * Any further attempt to perform most operations on the BytesIO 
   * after calling `delete()` will raise an exception.
   * 
   * @returns bool
   */
  delete() {
    self._source.dispose()
    self._do_close()
    self._source = nil
    self._max_length = -1
    self._position = -1
    ____FILESYSTEM____.remove(self._path)
    return true
  }

  /**
   * Returns `false` because BytesIO cannot be renamed.
   * 
   * @returns bool
   */
  rename(new_name) {
    if !self._file {
      raise Exception('file not found')
    }

    ____FILESYSTEM____.set(new_name, self._file)
    ____FILESYSTEM____.remove(self._path)
    self._path = new_name
    return true
  }

  /**
   * Returns a new BytesIO with the source cloned and opened with 
   * the same mode as the current BytesIO.
   * 
   * @returns [[io.BytesIO]]
   */
  copy(path) {
    if !self._file {
      raise Exception('file not found')
    }

    catch {
      ____FILESYSTEM____.set(path, self._file.clone())
      ____FILESYSTEM____[path].content = self._source.clone()
      ____FILESYSTEM____[path].ctime = (
        ____FILESYSTEM____[path].atime = (
          ____FILESYSTEM____[path].mtime = time()
        )
      )

      return true
    }

    return false
  }

  /**
   * Returns an empty string because BytesIO do not have any 
   * physical path.
   * 
   * @returns string
   */
  path() {
    return self._path
  }

  /**
   * Same as [[io.BytesIO.path()]].
   * 
   * @returns string
   */
  abs_path() {
    return self._file ? self._path : ''
  }

  /**
   * Truncates the entire BytesIO if length is not given or truncates 
   * the BytesIO such that only length number of bytes is left in it.
   * 
   * @returns bool
   */
  truncate(length) {
    if !length length = 0
    if !is_number(length) {
      raise Exception('invalid I/O data truncation length')
    }

    if !self._file {
      raise Exception('file not found')
    }

    catch {
      self._max_length = length
      var copy = self._source[,self._max_length]
      self._source.dispose()
      self._source.extend(copy)
      copy.dispose()
      return true
    }

    return false
  }
  
  /**
   * Returns `false` because BytesIO do not have a permission scheme.
   * 
   * @returns bool
   */
  chmod(number) {
    if !is_number(number) {
      raise Exception('chmod() expects argument 1 as number, ${typeof(number)} given')
    }

    if !self._file {
      raise Exception('file not found')
    }

    self._file.mode = number
    return false
  }

  /**
   * Sets the last access time and last modified time of the BytesIO.
   * 
   * @return bool
   */
  set_times(atime, mtime) {
    if !is_number(atime) {
      raise Exception('atime must be a number')
    } else if !is_number(mtime) {
      raise Exception('mtime must be a number')
    }

    if !self._file {
      raise Exception('file not found')
    }

    if atime != -1 self._file.atime = atime
    if mtime != -1 self._file.mtime = mtime
    return true
  }

  /**
   * Sets the position of a BytesIO reader or writer in a BytesIO. 
   * 
   * The position must be within the range of the BytesIO size. The 
   * `seek_type` argument must be on of [[io.SEEK_SET]], 
   * [[io.SEEK_CUR]] or [[io.SEEK_END]].
   * 
   * @returns bool
   */
  seek(position, seek_type) {
    if !is_number(position) {
      raise Exception('invalid I/O seek position')
    }

    if seek_type == nil seek_type = 0
    if !is_number(seek_type) or seek_type < 0 or seek_type > 2 {
      raise Exception('invalid seek type')
    }

    if !self._file {
      raise Exception('file not found')
    }

    using seek_type {
      when 0 self._position = position
      when 1 self._position += position
      when 2 self._position = self._source.length() - position
    }
  }

  /**
   * Returns the current position of the reader/writer in the BytesIO.
   * 
   * @return number
   */
  tell() {
    return self._file ? self._position : -1
  }

  /**
   * Returns the mode in which the current BytesIO was opened.
   * 
   * @return string
   */
  mode() {
    return self._mode
  }

  /**
   * Returns an empty string since BytesIO do not have a name.
   * 
   * @returns string
   */
  name() {
    return self._path.split('/', false)[-1]
  }

  _can_read() {
    # seperated just to be deliberate about it
    if os.dir_exists(self._path) {
      return false
    }

    return self.exists() and self._open and 
      to_bool(
        self._mode.index_of('r') or 
        self._mode.index_of('+') or 
        self._mode.index_of('a')
      )
  }

  _can_write() {
    # seperated just to be deliberate about it
    if os.dir_exists(self._path) {
      return false
    }

    return self._open and to_bool(
      self._mode.index_of('w') or 
      self._mode.index_of('+') or 
      self._mode.index_of('a')
    )
  }

  _should_append() {
    return self._mode.index_of('+') or 
      self._mode.index_of('a')
  }

  _do_open() {
    self._open = true
    self._max_length = self._source.length()
    self._position = 0
  }

  _do_close() {
    self._open = false
    self._max_length = 0
    self._position = self._source.length() + 1
  }

  _read(length) {
    if !self._can_read() {
      raise Exception('NotFound -> no such file or directory')
    }

    var max_readable = self._max_length - self._position
    if max_readable < 1 {
      return self._is_binary ? bytes(0) : ''
    }

    var result
    if length >= max_readable {
      result = self._source[self._position,]
    } else {
      result = self._source[self._position, self._position + length]
    }

    self._file.atime = time()

    self._position += length
    return self._is_binary ? result : result.to_string()
  }

  _write(data) {
    if !self._can_write() {
      raise Exception('Unsupported -> cannot write into non-writable file')
    }

    if self._max_length - self._position < 0 {
      raise Exception('cannot write beyond I/O offsets')
    }

    if self._should_append() {
      self._source += data
    } else {
      self._source.dispose()
      self._source.extend(data)
    }

    self._max_length += self._source.length()
    self._file.mtime = time()

    return data.length()
  }
}


# replace file()
import reflect
reflect.set_global(file)
