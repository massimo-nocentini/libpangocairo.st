# pharo-pango
A library to manage [pango fonts](http://www.pango.org) within [Pharo](http://pharo.org)

# Usage
This is made for macOS for the moment (adding linux and windows support should be trivial).  

### Prerequisites 
you need to have pango installed on your system: 

- macOS: `sudo port install pango`
- linux: ...
- windows: ...

### Installing
```Smalltalk
Metacello new 
	repository: 'github://estebanlm/pharo-pango/src';
	baseline: 'Pango';
	load.
```
**WARNING:** Since this is just an experiment and it uses cairo as backend, you need to modify `CairoLibrary` to point to the same version of cairo pango uses. In macOS, I made this: 

```Smalltalk 
CairoLibrary>>macModuleName
	^ '/opt/local/lib/libcairo.dylib'
```

### Trying it
You can execute the examples:

```Smalltalk
PangoExamples example1
```
