// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.
module.exports = {
  config: {
    /**
     * User interface font family with optional fallbacks.
     * @type {string}
     * @defaultvalue 
     */
    uiFontFamily: '"Operator SSm", "Fira Sans"',
    // font family with optional fallbacks
    fontFamily: '"Operator Mono SSm Lig", "Operator Mono Lig", "Fira Code Retina", "Fira Code", Ligconsolata, "Operator Mono", "Fira Mono", Inconsolata',
    // default font size in pixels for all tabs
    fontSize: 14,
    // default font weight: 'normal' or 'bold'
    // fontWeight: 'normal',
    // font weight for bold characters: 'normal' or 'bold'
    // fontWeightBold: 'bold',
    lineHeight: 1.6180339887498948482,
    // custom padding (CSS format, i.e.: `top right bottom left`)
    padding: '1em',
    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    // colors: {
    //   lightBlack:   '#002b36',
    //   black:        '#073642',
    //   lightGreen:   '#586e75',
    //   lightYellow:  '#657b83',
    //   lightBlue:    '#839496',
    //   lightCyan:    '#93a1a1',
    //   white:        '#eee8d5',
    //   lightWhite:   '#fdf6e3',
    //   yellow:       '#b58900',
    //   lightRed:     '#cb4b16',
    //   red:          '#dc322f',
    //   magenta:      '#d33682',
    //   lightMagenta: '#6c71c4',
    //   blue:         '#268bd2',
    //   cyan:         '#2aa198',
    //   green:        '#859900'
    // },
    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    // cursorColor: '#d33682',
    // terminal text color under BLOCK cursor
    // cursorAccentColor: '#002b36',
    // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
    // cursorShape: 'BLOCK',
    // set to `true` (without backticks and without quotes) for blinking cursor
    // cursorBlink: false,
    // color of the text
    // foregroundColor: '#839496',
    // terminal background color
    // opacity is only supported on macOS
    // backgroundColor: '#002b36',
    // terminal selection color
    // selectionColor: '#d33682',
    // border color (window, tabs)
    // borderColor: '#073642',
    // custom CSS to embed in the main window
    // css: '',
    // custom CSS to embed in the terminal window
    // termCSS: '',

    // set to `false` for no bell
    bell: true,
    // URL to custom bell
    bellSoundURL: 'http://www.orangefreesounds.com/wp-content/uploads/2014/08/Mario-coin-sound.mp3',
    // if `true` (without backticks and without quotes), selected text will automatically be copied to the clipboard
    // copyOnSelect: false,
    // if `true` (without backticks and without quotes), hyper will be set as the default protocol client for SSH
    // defaultSSHApp: true,
    // if `true` (without backticks and without quotes), on right click selected text will be copied or pasted if no
    // selection is present (`true` by default on Windows and disables the context menu feature)
    // quickEdit: true,

    // if you're using a Linux setup which show native menus, set to false
    // default: `true` on Linux, `true` on Windows, ignored on macOS
    // showHamburgerMenu: true,
    // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
    // showWindowControls: true,
    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    //
    // Windows
    // - Make sure to use a full path if the binary name doesn't work
    // - Remove `--login` in shellArgs
    //
    // Bash on Windows
    // - Example: `C:\\Windows\\System32\\bash.exe`
    //
    // PowerShell on Windows
    // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
    shell: 'C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
    // for setting shell arguments (i.e. for using interactive shellArgs: `['-i']`)
    // by default `['--login']` will be used
    shellArgs: ['-NoLogo'],
    // for environment variables
    //env: {},

    // choose either `'stable'` for receiving highly polished,
    // or `'canary'` for less polished but more frequent updates
    updateChannel: 'canary',
    // for advanced config flags please refer to https://hyper.is/#cfg
    hypercwd: {
      initialWorkingDirectory: '~'
    },
    // solarized: {
    //   colorscheme: 'dark',
    // },
  // List of other shells to add to launch menu
    otherShells: [
      { shell: "C:\\Windows\\System32\\bash.exe", shellArgs: [], shellName: "Bash" },
      { shell: "C:\\Windows\\System32\\cmd.exe", shellArgs: [], shellName: "Command prompt" },
      { shell: "C:\\Program Files\\Git\\bin\\bash.exe", shellArgs: ["--login"], shellName: "Git Bash" },
      { shell: "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", shellArgs: ["-NoLogo"], shellName: "Powershell" },
      { shell: "C:\\Python37\\python.exe", shellArgs: ["-q"], shellName: "Python" }
    ],
  },
 // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    'hypercwd',
    //'hyper-color-command',
    'hyper-launch-menu',
    'hyper-letters',
    //'hyper-solarized',
    //'hyperpower',
    'hyper-search',
    'hyper-single-instance'
  ],
  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: ['hyper-solarized-live'],
  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  },
};