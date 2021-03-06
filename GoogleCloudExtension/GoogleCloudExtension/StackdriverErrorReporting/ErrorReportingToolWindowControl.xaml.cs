﻿// Copyright 2017 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using System.Windows;
using System.Windows.Controls;

namespace GoogleCloudExtension.StackdriverErrorReporting
{
    /// <summary>
    /// Interaction logic for ErrorReportingToolWindowControl.
    /// </summary>
    public partial class ErrorReportingToolWindowControl : UserControl
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ErrorReportingToolWindowControl"/> class.
        /// </summary>
        public ErrorReportingToolWindowControl()
        {
            InitializeComponent();
        }

        private void ErrorReportingToolWindowControl_OnIsVisibleChanged(object sender, DependencyPropertyChangedEventArgs e)
        {
            var viewModel = DataContext as ErrorReportingViewModel;
            if (viewModel != null)
            {
                viewModel.IsVisibleUnbound = (bool) e.NewValue;
            }
        }
    }
}