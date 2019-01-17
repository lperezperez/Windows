namespace Windows.Shell
{
    using System;
    using System.Drawing;
    using System.Runtime.InteropServices;
    using Microsoft.Win32;
    /// <summary>Signatures that identifies the type of data block that follows the header.</summary>
    public enum DataBlockSignature : uint
    {
        /// <summary>The <see cref="ConsoleProperties"/> signature.</summary>
        ConsoleProperties = 0xA0000002
    }
    /// <summary>The Solarized color mode.</summary>
    public enum SolarizedMode
    {
        /// <summary>The dark color mode.</summary>
        Dark,
        /// <summary>The light color mode.</summary>
        Light
    }
    /// <summary>Enables an object to be loaded from or saved to a disk file, rather than a storage object or stream.</summary>
    [ComImport, InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid("0000010B-0000-0000-C000-000000000046")]
    public interface IPersistFile
    {
        #region IPersist methods
        /// <summary>Retrieves the class identifier (CLSID) of the object.</summary>
        /// <param name="handleClassId">
        ///     A pointer to the location that receives the CLSID on return. The CLSID is a globally unique identifier (GUID) that uniquely represents an object class that defines the code that can manipulate the object's data.
        /// </param>
        void GetClassID(out Guid handleClassId);
        #endregion
        /// <summary>Determines whether an object has changed since it was last saved to its current file.</summary>
        /// <returns>This method returns S_OK to indicate that the object has changed. Otherwise, it returns S_FALSE.</returns>
        [PreserveSig]
        int IsDirty();
        /// <summary>Loads the specified file name.</summary>
        /// <param name="fileName">The absolute path of the file to be opened.</param>
        /// <param name="mode">
        ///     The access mode to be used when opening the file. Possible values are taken from the STGM enumeration. The method can treat this value as a suggestion, adding more restrictive permissions if necessary. If dwMode is 0, the implementation should open the file using whatever default permissions are used when a user opens the file.
        /// </param>
        void Load([MarshalAs(UnmanagedType.LPWStr)] string fileName, int mode);
        /// <summary>Saves a copy of the object to the specified file.</summary>
        /// <param name="fileName">
        ///     The absolute path of the file to which the object should be saved. If is <see langword="null"/>, the object will save its data to the current file, if there is one.
        /// </param>
        /// <param name="remember">
        ///     Indicates whether the <paramref name="fileName"/> parameter is to be used as the current working file. If <see langword="true"/>, <paramref name="fileName"/> becomes the current path for the file and the object should clear its dirty flag after the save. If <see langword="false"/>, this save operation is a Save A Copy As... operation. In this case, the current file is unchanged and the object should not clear its dirty flag. If <paramref name="fileName"/> is <see langword="null"/>, the implementation should ignore this flag.
        /// </param>
        void Save([MarshalAs(UnmanagedType.LPWStr)] string fileName, [MarshalAs(UnmanagedType.Bool)] bool remember);
    }
    /// <summary>
    ///     Exposes methods that allow an application to attach extra data blocks to a Shell link. These methods add, copy, or remove data blocks.
    /// </summary>
    /// <remarks>
    ///     The data blocks are in the form of a structure. The first two members are the same for all data blocks. The first member gives the structure's size. The second member is a signature that identifies the type of data block. The remaining members hold the block's data. There are five types of data block currently supported.
    /// </remarks>
    [ComImport, InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid("45E2b4AE-B1C3-11D0-B92F-00A0C90312E1")]
    public interface IShellLinkDataList
    {
        /// <summary>Adds a data block to a link.</summary>
        /// <param name="dataBlockHandle">The data block structure. For a list of supported structures, see <see cref="IShellLinkDataList"/>.</param>
        void AddDataBlock(IntPtr dataBlockHandle);
        /// <summary>Retrieves a copy of a link's data block.</summary>
        /// <param name="dataBlockSignature">
        ///     The data block's signature. The signature value for a particular type of data block can be found in its structure reference. For a list of supported data block types and their associated structures, see <see cref="IShellLinkDataList"/>.
        /// </param>
        /// <param name="dataBlockHandle">
        ///     The address of a pointer to a copy of the data block structure. If <see cref="IShellLinkDataList.CopyDataBlock"/> returns a successful result, the calling application must free the memory when it is no longer needed by calling LocalFree.
        /// </param>
        void CopyDataBlock(DataBlockSignature dataBlockSignature, out IntPtr dataBlockHandle);
        /// <summary>Removes a data block from a link.</summary>
        /// <param name="dataBlockSignature">
        ///     The data block's signature. The signature value for a particular type of data block can be found in its structure reference. For a list of supported data block types and their associated structures, see <see cref="IShellLinkDataList"/>.
        /// </param>
        void RemoveDataBlock(DataBlockSignature dataBlockSignature);
    }
    /// <summary>Exposes methods that create, modify, and resolve Shell links.</summary>
    [ComImport, InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid("000214F9-0000-0000-C000-000000000046")]
    public interface IShellLinkW { }
    /// <summary>
    ///     Holds an extra data block used by <see cref="IShellLinkDataList"/>. It holds <see href="https://msdn.microsoft.com/en-us/library/windows/desktop/bb773359%28v=vs.85%29.aspx">console properties</see>.
    /// </summary>
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct ConsoleProperties
    {
        /// <summary>The size of the extra data block.</summary>
        public int Size;
        /// <summary>A signature that identifies the type of data block that follows the header.</summary>
        public DataBlockSignature Signature;
        /// <summary>Background and text colors value for console.</summary>
        public ushort ScreenColors;
        /// <summary>Background and text colors value for console pop-ups.</summary>
        public ushort PopupColors;
        /// <summary>The screen buffer size.</summary>
        public Coord ScreenBufferSize;
        /// <summary>The window size.</summary>
        public Coord WindowSize;
        /// <summary>The window start position.</summary>
        public Coord WindowOrigin;
        /// <summary>The font.</summary>
        public int Font;
        /// <summary>The input buffer size.</summary>
        public int InputBufferSize;
        /// <summary>The font size.</summary>
        public Coord FontSize;
        /// <summary>The font family.</summary>
        public int FontFamily;
        /// <summary>The font weight.</summary>
        public int FontWeight;
        /// <summary>The font's face name.</summary>
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string FaceName;
        /// <summary>The cursor size.</summary>
        public int CursorSize;
        /// <summary>A value indicating whether the console is in full screen mode.</summary>
        public bool FullScreen;
        /// <summary>A value indicating whether the console is in quick-edit mode.</summary>
        public bool QuickEdit;
        /// <summary>A value indicating whether the console is in insert mode.</summary>
        public bool InsertMode;
        /// <summary>A value indicating whether the console is in auto-position mode.</summary>
        public bool AutoPosition;
        /// <summary>The size of the history buffer.</summary>
        public int HistoryBufferSize;
        /// <summary>The number of history buffers.</summary>
        public int NumberOfHistoryBuffers;
        /// <summary>A value indicating whether the old duplicate history lists should be discarded.</summary>
        public bool HistoryNoDup;
        /// <summary>
        ///     An array of <see href="https://msdn.microsoft.com/en-us/library/windows/desktop/dd183449(v=vs.85).aspx">COLORREF</see> values with the console's color settings.
        /// </summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 16)]
        public int[] ColorTable;
        /// <summary>Initializes a new instance of the <see cref="ConsoleProperties"/> <see langword="struct"/>.</summary>
        /// <param name="font">The font value.</param>
        public ConsoleProperties(int font)
        {
            this.Size = Marshal.SizeOf(typeof(ConsoleProperties));
            this.Signature = DataBlockSignature.ConsoleProperties;
            this.AutoPosition = true;
            const string RegistryKeyConsole = "HKEY_CURRENT_USER\\Console";
            this.ColorTable = new int[16];
            for (var index = 0; index < 16; index++)
                this.ColorTable[index] = (int)Registry.GetValue(RegistryKeyConsole, "ColorTable" + index.ToString("00"), 0);
            this.CursorSize = (int)Registry.GetValue(RegistryKeyConsole, "CursorSize", 25);
            this.FaceName = Registry.GetValue(RegistryKeyConsole, "FaceName", "Fira Code Retina").ToString();
            this.Font = font;
            this.FontFamily = (int)Registry.GetValue(RegistryKeyConsole, "FontFamily", 54);
            this.FontSize = new Coord(0x180000);
            this.FontWeight = (int)Registry.GetValue(RegistryKeyConsole, "FontWeight", 700);
            this.FullScreen = (bool)Registry.GetValue(RegistryKeyConsole, "FullScreen", false);
            this.InputBufferSize = 0;
            this.InsertMode = (bool)Registry.GetValue(RegistryKeyConsole, "InsertMode", true);
            this.HistoryBufferSize = (int)Registry.GetValue(RegistryKeyConsole, "HistoryBufferSize", 50);
            this.HistoryNoDup = (bool)Registry.GetValue(RegistryKeyConsole, "HistoryNoDup", true);
            this.NumberOfHistoryBuffers = (int)Registry.GetValue(RegistryKeyConsole, "NumberOfHistoryBuffers", 4);
            this.PopupColors = (ushort)Registry.GetValue(RegistryKeyConsole, "PopupColors", 0xf6);
            this.QuickEdit = Convert.ToBoolean(Registry.GetValue(RegistryKeyConsole, "QuickEdit", true));
            this.ScreenBufferSize = new Coord((int)Registry.GetValue(RegistryKeyConsole, "ScreenBufferSize", 0x23290078));
            this.ScreenColors = (ushort)Registry.GetValue(RegistryKeyConsole, "ScreenColors", 0x1);
            this.WindowOrigin = new Coord();
            this.WindowSize = new Coord((int)Registry.GetValue(RegistryKeyConsole, "WindowSize", 0x1e0078));
        }
    }
    /// <summary>Defines the coordinates of a character cell in a console screen buffer.</summary>
    /// <seealso href="https://docs.microsoft.com/en-us/windows/console/coord-str">COORD struct.</seealso>
    [StructLayout(LayoutKind.Sequential)]
    public struct Coord
    {
        /// <summary>The horizontal coordinate or column value. The units depend on the function call.</summary>
        public short X;
        /// <summary>The vertical coordinate or row value. The units depend on the function call.</summary>
        public short Y;
        /// <summary>Initializes a new instance of the <see cref="Coord"/>  <see langword="struct"/>.</summary>
        /// <param name="coord">The <see cref="int"/> representation of the <see cref="Coord"/>.</param>
        public Coord(int coord)
        {
            var point = new Point(coord);
            this.X = (short)point.X;
            this.Y = (short)point.Y;
        }
    }
    /// <summary>Provides methods to modify a Windows shell link.</summary>
    public static class Link
    {
        #region Methods
        /// <summary>Sets the specified <paramref name="solarizedMode"/>.</summary>
        /// <param name="solarizedMode">The specified <see cref="SolarizedMode"/>.</param>
        /// <param name="lnk">The .lnk file path.</param>
        public static void SetSolarizedMode(SolarizedMode solarizedMode, string lnk)
        {
            var shellLink = Activator.CreateInstance(Type.GetTypeFromCLSID(new Guid("00021401-0000-0000-C000-000000000046"))) as IShellLinkW;
            ((IPersistFile)shellLink).Load(lnk, 0);
            IntPtr handleConsoleProperties = IntPtr.Zero;
            ((IShellLinkDataList)shellLink).CopyDataBlock(DataBlockSignature.ConsoleProperties, out handleConsoleProperties);
            var consoleProperties = (ConsoleProperties)Marshal.PtrToStructure(handleConsoleProperties, typeof(ConsoleProperties));
            // Initialize default Console Properties
            if (consoleProperties.Signature != DataBlockSignature.ConsoleProperties)
                consoleProperties = new ConsoleProperties(0);
            consoleProperties.AutoPosition = true;
            // Set Common Solarized Colors.
            consoleProperties.ColorTable[0] = HexToWin32("#002b36");
            consoleProperties.ColorTable[8] = HexToWin32("#073642");
            consoleProperties.ColorTable[2] = HexToWin32("#586e75");
            consoleProperties.ColorTable[6] = HexToWin32("#657b83");
            consoleProperties.ColorTable[1] = HexToWin32("#839496");
            consoleProperties.ColorTable[3] = HexToWin32("#93a1a1");
            consoleProperties.ColorTable[7] = HexToWin32("#eee8d5");
            consoleProperties.ColorTable[15] = HexToWin32("#fdf6e3");
            consoleProperties.ColorTable[14] = HexToWin32("#b58900");
            consoleProperties.ColorTable[4] = HexToWin32("#cb4b16");
            consoleProperties.ColorTable[12] = HexToWin32("#dc322f");
            consoleProperties.ColorTable[13] = HexToWin32("#d33682");
            consoleProperties.ColorTable[5] = HexToWin32("#6c71c4");
            consoleProperties.ColorTable[9] = HexToWin32("#268bd2");
            consoleProperties.ColorTable[11] = HexToWin32("#2aa198");
            consoleProperties.ColorTable[10] = HexToWin32("#859900");
            const string RegistryKeyConsole = "HKEY_CURRENT_USER\\Console";
            for (var index = 0; index < 16; index++)
                Registry.SetValue(RegistryKeyConsole, "ColorTable" + index.ToString("00"), consoleProperties.ColorTable[index]);
            // Set Light/Dark color mode.
            consoleProperties.ScreenColors = solarizedMode == SolarizedMode.Dark ? GetColors(0, 1) : GetColors(15, 6);
            Registry.SetValue(RegistryKeyConsole, "ScreenColors", (int)consoleProperties.ScreenColors);
            consoleProperties.PopupColors = solarizedMode == SolarizedMode.Dark ? GetColors(15, 6) : GetColors(0, 1);
            Registry.SetValue(RegistryKeyConsole, "PopupColors", (int)consoleProperties.PopupColors);
            // Set Font.
            Registry.SetValue(RegistryKeyConsole, "FaceName", consoleProperties.FaceName = "Inconsolata");
            Registry.SetValue(RegistryKeyConsole, "FontFamily", consoleProperties.FontFamily = 0x36);
            consoleProperties.FontSize = new Coord(0x180000);
            Registry.SetValue(RegistryKeyConsole, "FontSize", 0x180000);
            Registry.SetValue(RegistryKeyConsole, "FontWeight", consoleProperties.FontWeight = 700);
            Registry.SetValue(RegistryKeyConsole, "HistoryBufferSize", consoleProperties.HistoryBufferSize = 80);
            consoleProperties.WindowSize.X = 80;
            consoleProperties.WindowSize.Y = 25;
            // Save the Windows Link file.
            handleConsoleProperties = Marshal.AllocCoTaskMem(consoleProperties.Size);
            Marshal.StructureToPtr(consoleProperties, handleConsoleProperties, true);
            ((IShellLinkDataList)shellLink).RemoveDataBlock(DataBlockSignature.ConsoleProperties);
            ((IShellLinkDataList)shellLink).AddDataBlock(handleConsoleProperties);
            ((IPersistFile)shellLink).Save(null, true);
        }
        /// <summary>Gets the colors value.</summary>
        /// <param name="backgroundTableColorIndex">Index of <see cref="ConsoleProperties.ColorTable"/> for background color.</param>
        /// <param name="textTableColorIndex">Index of <see cref="ConsoleProperties.ColorTable"/> for text color.</param>
        /// <returns>The colors value.</returns>
        private static ushort GetColors(byte backgroundTableColorIndex, byte textTableColorIndex) { return (ushort)((backgroundTableColorIndex << 4) + textTableColorIndex); }
        /// <summary>Gets a Windows <see cref="Color"/> from the specified <paramref name="htmlColor"/>.</summary>
        /// <param name="htmlColor">HTML <see cref="Color"/> representation.</param>
        /// <returns>Windows <see cref="Color"/> representation.</returns>
        private static int HexToWin32(string htmlColor) { return ColorTranslator.ToWin32(ColorTranslator.FromHtml(htmlColor)); }
        #endregion
    }
}