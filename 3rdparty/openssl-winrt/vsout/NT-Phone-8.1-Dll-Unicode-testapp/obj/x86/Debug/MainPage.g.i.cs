﻿#pragma checksum "K:\dev\mobile\moaiforge\sdks\moaiforge\3rdparty\openssl-winrt\vsout\NT-Phone-8.1-Dll-Unicode-testapp\MainPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "219E9F54266458C2562A83D001E2C068"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34209
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using Microsoft.Phone.Controls;
using System;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Automation.Peers;
using System.Windows.Automation.Provider;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Resources;
using System.Windows.Shapes;
using System.Windows.Threading;


namespace OpenSSLTestApp {
    
    
    public partial class MainPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.StackPanel MainPanel;
        
        internal System.Windows.Controls.TextBlock Title;
        
        internal System.Windows.Controls.Button RunTests;
        
        internal System.Windows.Controls.Grid ContentPanel;
        
        internal System.Windows.Controls.ListBox Tests;
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Windows.Application.LoadComponent(this, new System.Uri("/OpenSSLTestApp;component/MainPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.MainPanel = ((System.Windows.Controls.StackPanel)(this.FindName("MainPanel")));
            this.Title = ((System.Windows.Controls.TextBlock)(this.FindName("Title")));
            this.RunTests = ((System.Windows.Controls.Button)(this.FindName("RunTests")));
            this.ContentPanel = ((System.Windows.Controls.Grid)(this.FindName("ContentPanel")));
            this.Tests = ((System.Windows.Controls.ListBox)(this.FindName("Tests")));
        }
    }
}

