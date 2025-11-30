classdef communication_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        Label                          matlab.ui.control.Label
        InputSignalPortionPanel        matlab.ui.container.Panel
        UIAxes                         matlab.ui.control.UIAxes
        InputSectionFunctionoftPanel   matlab.ui.container.Panel
        UserDefinedSignalEditFieldLabel  matlab.ui.control.Label
        UserDefinedSignalEditField     matlab.ui.control.EditField
        StartingTimeEditFieldLabel     matlab.ui.control.Label
        StartingTimeEditField          matlab.ui.control.EditField
        EndingTimeEditFieldLabel       matlab.ui.control.Label
        EndingTimeEditField            matlab.ui.control.EditField
        ProcessButton                  matlab.ui.control.Button
        ModulationIndexEditField_3Label  matlab.ui.control.Label
        ModulationIndexEditField_3     matlab.ui.control.EditField
        OtherSignalSummaryPanel        matlab.ui.container.Panel
        TabGroup                       matlab.ui.container.TabGroup
        CarrierSignalTab               matlab.ui.container.Tab
        AfterModulationPanel           matlab.ui.container.Panel
        UIAxes3                        matlab.ui.control.UIAxes
        CarrierSignalPanel             matlab.ui.container.Panel
        UIAxes2                        matlab.ui.control.UIAxes
        VariationPanelForUserDefinedFunction  matlab.ui.container.Panel
        CarrierFrequencyHzSliderLabel  matlab.ui.control.Label
        CarrierFrequencyHzSlider       matlab.ui.control.Slider
        OutputSignalTab                matlab.ui.container.Tab
        OutputresponseofuserdefinedTransmittedSignalPanel  matlab.ui.container.Panel
        UIAxes4                        matlab.ui.control.UIAxes
        VariationPanelForuserdefinedSignal  matlab.ui.container.Panel
        CarrierFrequencyHzSlider_2Label  matlab.ui.control.Label
        CarrierFrequencyHzSlider_2     matlab.ui.control.Slider
        OutputGainForuserdefinedSignalPanel  matlab.ui.container.Panel
        FrequencyHzSlider_3            matlab.ui.control.Slider
        CarrierFrequencyHzSlider_2Label_2  matlab.ui.control.Label
        PLLDemodulatorTab              matlab.ui.container.Tab
        PhaseDetectorOutputPanel       matlab.ui.container.Panel
        UIAxes5                        matlab.ui.control.UIAxes
        VCOVoltageControlledOscillatorOutputPanel  matlab.ui.container.Panel
        UIAxes6                        matlab.ui.control.UIAxes
        VoiceInputTab                  matlab.ui.container.Tab
        ActionCenterPanel              matlab.ui.container.Panel
        UIAxes7                        matlab.ui.control.UIAxes
        VariationPanel                 matlab.ui.container.Panel
        GainSliderLabel                matlab.ui.control.Label
        GainSlider                     matlab.ui.control.Slider
        CarrierFrequencyHzSlider_3Label  matlab.ui.control.Label
        CarrierFrequencyHzSlider_3     matlab.ui.control.Slider
        RecordSignalButton             matlab.ui.control.Button
        VoiceRecordingDurationis5secondLabel  matlab.ui.control.Label
        ModulationOutputSwitchLabel    matlab.ui.control.Label
        ModulationOutputSwitch         matlab.ui.control.Switch
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ProcessButton
        function ProcessButtonPushed(app, event)
            fun_t=app.UserDefinedSignalEditField.Value;
            t1=app.StartingTimeEditField.Value;
            t2=app.EndingTimeEditField.Value;
            t3=str2num(t1);
            t4=str2num(t2);
            t=t3:0.00001:t4;
            fun=eval(fun_t);
            plot(app.UIAxes,t,fun,'black');
        end

        % Callback function
        function PlotButton_3Pushed(app, event)
            
        end

        % Callback function
        function PlotButton_5Pushed(app, event)
            t1=app.StartingTimeEditField.Value;
            t2=app.EndingTimeEditField.Value;
            t3=str2num(t1);
            t4=str2num(t2);
            t=t3:0.00001:t4; 
            f=app.CarrierFrequencyHzSlider.Value;
            fs=100*f;
            m=str2num(app.ModulationIndexEditField.Value);
            msg_in=app.UserDefinedSignalEditField.Value;
            msg=eval(msg_in);
            signal=exp(j*(2*pi*f*t+2*pi*m*cumsum(msg)));
            phi_hat(1)=30; 
            e(1)=0; 
            phd_output(1)=0; 
            vco(1)=0; 
            %Define Loop Filter parameters(Sets damping)
            kp=0.15; %Proportional constant 
            ki=0.1; %Integrator constant 
            %PLL implementation 
            for n=2:length(signal) 
            vco(n)=conj(exp(j*(2*pi*n*f/fs+phi_hat(n-1))));%Compute VCO 
            phd_output(n)=imag(signal(n)*vco(n));%Complex multiply VCO x Signal input 
            e(n)=e(n-1)+(kp+ki)*phd_output(n)-ki*phd_output(n-1);%Filter integrator 
            phi_hat(n)=phi_hat(n-1)+e(n);%Update VCO 
            end
            plot(app.UIAxes6,t,real(vco),'black');
        end

        % Value changed function: CarrierFrequencyHzSlider
        function CarrierFrequencyHzSliderValueChanged(app, event)
            t1=app.StartingTimeEditField.Value;
            t2=app.EndingTimeEditField.Value;
            t3=str2num(t1);
            t4=str2num(t2);
            t=t3:0.00001:t4;
            f=app.CarrierFrequencyHzSlider.Value;
            y=cos(2*pi*f*t);
            m=str2num(app.ModulationIndexEditField_3.Value);
            msg_in=app.UserDefinedSignalEditField.Value;
            msg=eval(msg_in);
            Signal=exp(j*(2*pi*f*t+2*pi*m*cumsum(msg)));
            plot(app.UIAxes2,t,y,'black');
            plot(app.UIAxes3,t, real(Signal),'black');
        end

        % Value changed function: CarrierFrequencyHzSlider_2
        function CarrierFrequencyHzSlider_2ValueChanged(app, event)
            t1=app.StartingTimeEditField.Value;
            t2=app.EndingTimeEditField.Value;
            t3=str2num(t1);
            t4=str2num(t2);
            t=t3:0.00001:t4; 
            f=app.CarrierFrequencyHzSlider_2.Value;
            fs=100*f;
            m=str2num(app.ModulationIndexEditField_3.Value);
            msg_in=app.UserDefinedSignalEditField.Value;
            msg=eval(msg_in);
            signal=exp(j*(2*pi*f*t+2*pi*m*cumsum(msg)));
            phi_hat(1)=30; 
            e(1)=0; 
            phd_output(1)=0; 
            vco(1)=0; 
            %Define Loop Filter parameters(Sets damping)
            kp=0.15; %Proportional constant 
            ki=0.1; %Integrator constant 
            %PLL implementation 
            for n=2:length(signal) 
            vco(n)=conj(exp(j*(2*pi*n*f/fs+phi_hat(n-1))));%Compute VCO 
            phd_output(n)=imag(signal(n)*vco(n));%Complex multiply VCO x Signal input 
            e(n)=e(n-1)+(kp+ki)*phd_output(n)-ki*phd_output(n-1);%Filter integrator 
            phi_hat(n)=phi_hat(n-1)+e(n);%Update VCO 
            end
            plot(app.UIAxes5,t,phd_output,'black');
            plot(app.UIAxes6,t,real(vco),'black');
            plot(app.UIAxes4,t,e,'black');
        end

        % Value changed function: FrequencyHzSlider_3
        function FrequencyHzSlider_3ValueChanged(app, event)
            t1=app.StartingTimeEditField.Value;
            t2=app.EndingTimeEditField.Value;
            t3=str2num(t1);
            t4=str2num(t2);
            t=t3:0.00001:t4; 
            f=app.CarrierFrequencyHzSlider_2.Value;
            fs=100*f;
            m=str2num(app.ModulationIndexEditField_3.Value);
            msg_in=app.UserDefinedSignalEditField.Value;
            msg=eval(msg_in);
            signal=exp(j*(2*pi*f*t+2*pi*m*cumsum(msg)));
            phi_hat(1)=30; 
            e(1)=0; 
            phd_output(1)=0; 
            vco(1)=0; 
            %Define Loop Filter parameters(Sets damping)
            kp=0.15; %Proportional constant 
            ki=0.1; %Integrator constant 
            %PLL implementation 
            for n=2:length(signal) 
            vco(n)=conj(exp(j*(2*pi*n*f/fs+phi_hat(n-1))));%Compute VCO 
            phd_output(n)=imag(signal(n)*vco(n));%Complex multiply VCO x Signal input 
            e(n)=e(n-1)+(kp+ki)*phd_output(n)-ki*phd_output(n-1);%Filter integrator 
            phi_hat(n)=phi_hat(n-1)+e(n);%Update VCO 
            end
            gain=app.FrequencyHzSlider_3.Value;
            e=gain*e;
            plot(app.UIAxes4,t,e,'black');
        end

        % Button pushed function: RecordSignalButton
        function RecordSignalButtonPushed(app, event)
            h=waitbar(0.07,'Recording');
            Y=audiorecorder(1600,8,1);
            recordblocking(Y,5);
            myrecord=getaudiodata(Y);
            close(h);
            g=waitbar(0.59,'Processing');
            t=0:length(myrecord)-1;
            f=app.CarrierFrequencyHzSlider_3.Value;
            y=cos(2*pi*f*t);
            plot(app.UIAxes2,t,y,'black');
            m=str2num(app.ModulationIndexEditField_3.Value);
            msg=myrecord;
            Signal=exp(j*(2*pi*f*t+2*pi*m*cumsum(msg)));
            phi_hat(1)=30; 
            e(1)=0; 
            phd_output(1)=0; 
            vco(1)=0; 
            %Define Loop Filter parameters(Sets damping)
            kp=0.15; %Proportional constant 
            ki=0.1; %Integrator constant 
            %PLL implementation 
            fs=1600;
            for n=2:length(Signal) 
            vco(n)=conj(exp(j*(2*pi*n*f/fs+phi_hat(n-1))));%Compute VCO 
            phd_output(n)=imag(Signal(n)*vco(n));%Complex multiply VCO x Signal input 
            e(n)=e(n-1)+(kp+ki)*phd_output(n)-ki*phd_output(n-1);%Filter integrator 
            phi_hat(n)=phi_hat(n-1)+e(n);%Update VCO 
            end
            gain=app.GainSlider.Value;
            e=gain*e;
            plot(app.UIAxes,t,myrecord,'black');
            plot(app.UIAxes7,t,gain*e,'black');
            plot(app.UIAxes5,t,phd_output,'black');
            plot(app.UIAxes6,t,real(vco),'black');
            if strcmp(app.ModulationOutputSwitch.Value,'On')
            plot(app.UIAxes3,t,real(Signal),'black');
            end
            close(g);
        end

        % Size changed function: 
        % VariationPanelForUserDefinedFunction
        function VariationPanelForUserDefinedFunctionSizeChanged(app, event)
            position = app.VariationPanelForUserDefinedFunction.Position;
            
        end

        % Value changing function: CarrierFrequencyHzSlider
        function CarrierFrequencyHzSliderValueChanging(app, event)
            changingValue = event.Value;
            
        end

        % Value changed function: CarrierFrequencyHzSlider_3
        function CarrierFrequencyHzSlider_3ValueChanged(app, event)
            value = app.CarrierFrequencyHzSlider_3.Value;
            
        end

        % Value changed function: GainSlider
        function GainSliderValueChanged(app, event)
            value = app.GainSlider.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Position = [100 100 1385 722];
            app.UIFigure.Name = 'UI Figure';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontName = 'Cambria Math';
            app.Label.FontSize = 20;
            app.Label.FontWeight = 'bold';
            app.Label.Position = [244 682 902 35];
            app.Label.Text = 'Signal Transmit and Receive by Frequency Modulation and PLL Demodulation Method';

            % Create InputSignalPortionPanel
            app.InputSignalPortionPanel = uipanel(app.UIFigure);
            app.InputSignalPortionPanel.TitlePosition = 'centertop';
            app.InputSignalPortionPanel.Title = 'Input Signal Portion';
            app.InputSignalPortionPanel.BackgroundColor = [1 1 1];
            app.InputSignalPortionPanel.FontName = 'Cambria Math';
            app.InputSignalPortionPanel.FontWeight = 'bold';
            app.InputSignalPortionPanel.FontSize = 14;
            app.InputSignalPortionPanel.Position = [23 468 1343 206];

            % Create UIAxes
            app.UIAxes = uiaxes(app.InputSignalPortionPanel);
            title(app.UIAxes, 'Input Signal [Transmitted Signal]')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'Amplitude')
            app.UIAxes.FontName = 'Cambria Math';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.BackgroundColor = [1 1 1];
            app.UIAxes.Position = [615 6 685 172];

            % Create InputSectionFunctionoftPanel
            app.InputSectionFunctionoftPanel = uipanel(app.InputSignalPortionPanel);
            app.InputSectionFunctionoftPanel.TitlePosition = 'centertop';
            app.InputSectionFunctionoftPanel.Title = 'Input Section  [ Function of  t ]';
            app.InputSectionFunctionoftPanel.BackgroundColor = [1 1 1];
            app.InputSectionFunctionoftPanel.FontName = 'Cambria Math';
            app.InputSectionFunctionoftPanel.FontWeight = 'bold';
            app.InputSectionFunctionoftPanel.FontSize = 14;
            app.InputSectionFunctionoftPanel.Position = [24 8 521 168];

            % Create UserDefinedSignalEditFieldLabel
            app.UserDefinedSignalEditFieldLabel = uilabel(app.InputSectionFunctionoftPanel);
            app.UserDefinedSignalEditFieldLabel.HorizontalAlignment = 'right';
            app.UserDefinedSignalEditFieldLabel.FontName = 'Cambria Math';
            app.UserDefinedSignalEditFieldLabel.FontSize = 14;
            app.UserDefinedSignalEditFieldLabel.FontWeight = 'bold';
            app.UserDefinedSignalEditFieldLabel.Position = [21 116 127 22];
            app.UserDefinedSignalEditFieldLabel.Text = 'User Defined Signal';

            % Create UserDefinedSignalEditField
            app.UserDefinedSignalEditField = uieditfield(app.InputSectionFunctionoftPanel, 'text');
            app.UserDefinedSignalEditField.FontName = 'Cambria Math';
            app.UserDefinedSignalEditField.FontSize = 14;
            app.UserDefinedSignalEditField.Position = [163 116 348 22];

            % Create StartingTimeEditFieldLabel
            app.StartingTimeEditFieldLabel = uilabel(app.InputSectionFunctionoftPanel);
            app.StartingTimeEditFieldLabel.HorizontalAlignment = 'right';
            app.StartingTimeEditFieldLabel.FontName = 'Cambria Math';
            app.StartingTimeEditFieldLabel.FontSize = 14;
            app.StartingTimeEditFieldLabel.FontWeight = 'bold';
            app.StartingTimeEditFieldLabel.Position = [21 85 91 22];
            app.StartingTimeEditFieldLabel.Text = 'Starting Time';

            % Create StartingTimeEditField
            app.StartingTimeEditField = uieditfield(app.InputSectionFunctionoftPanel, 'text');
            app.StartingTimeEditField.FontName = 'Cambria Math';
            app.StartingTimeEditField.Position = [163 85 81 22];

            % Create EndingTimeEditFieldLabel
            app.EndingTimeEditFieldLabel = uilabel(app.InputSectionFunctionoftPanel);
            app.EndingTimeEditFieldLabel.HorizontalAlignment = 'right';
            app.EndingTimeEditFieldLabel.FontName = 'Cambria Math';
            app.EndingTimeEditFieldLabel.FontSize = 14;
            app.EndingTimeEditFieldLabel.FontWeight = 'bold';
            app.EndingTimeEditFieldLabel.Position = [331 85 84 22];
            app.EndingTimeEditFieldLabel.Text = 'Ending Time';

            % Create EndingTimeEditField
            app.EndingTimeEditField = uieditfield(app.InputSectionFunctionoftPanel, 'text');
            app.EndingTimeEditField.FontName = 'Cambria Math';
            app.EndingTimeEditField.Position = [430 85 81 22];

            % Create ProcessButton
            app.ProcessButton = uibutton(app.InputSectionFunctionoftPanel, 'push');
            app.ProcessButton.ButtonPushedFcn = createCallbackFcn(app, @ProcessButtonPushed, true);
            app.ProcessButton.BackgroundColor = [0 0 0];
            app.ProcessButton.FontName = 'Cambria Math';
            app.ProcessButton.FontColor = [1 1 1];
            app.ProcessButton.Position = [302 30 100 22];
            app.ProcessButton.Text = 'Process';

            % Create ModulationIndexEditField_3Label
            app.ModulationIndexEditField_3Label = uilabel(app.InputSectionFunctionoftPanel);
            app.ModulationIndexEditField_3Label.HorizontalAlignment = 'right';
            app.ModulationIndexEditField_3Label.FontName = 'Cambria Math';
            app.ModulationIndexEditField_3Label.FontWeight = 'bold';
            app.ModulationIndexEditField_3Label.Position = [21 50 99 22];
            app.ModulationIndexEditField_3Label.Text = 'Modulation Index';

            % Create ModulationIndexEditField_3
            app.ModulationIndexEditField_3 = uieditfield(app.InputSectionFunctionoftPanel, 'text');
            app.ModulationIndexEditField_3.FontName = 'Cambria Math';
            app.ModulationIndexEditField_3.Position = [163 51 81 22];
            app.ModulationIndexEditField_3.Value = '0.85';

            % Create OtherSignalSummaryPanel
            app.OtherSignalSummaryPanel = uipanel(app.UIFigure);
            app.OtherSignalSummaryPanel.TitlePosition = 'centertop';
            app.OtherSignalSummaryPanel.Title = 'Other Signal Summary';
            app.OtherSignalSummaryPanel.BackgroundColor = [1 1 1];
            app.OtherSignalSummaryPanel.FontName = 'Cambria Math';
            app.OtherSignalSummaryPanel.FontWeight = 'bold';
            app.OtherSignalSummaryPanel.FontSize = 14;
            app.OtherSignalSummaryPanel.Position = [23 18 1343 444];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.OtherSignalSummaryPanel);
            app.TabGroup.Position = [11 9 1322 409];

            % Create CarrierSignalTab
            app.CarrierSignalTab = uitab(app.TabGroup);
            app.CarrierSignalTab.Title = 'Carrier Signal';
            app.CarrierSignalTab.BackgroundColor = [1 1 1];

            % Create AfterModulationPanel
            app.AfterModulationPanel = uipanel(app.CarrierSignalTab);
            app.AfterModulationPanel.TitlePosition = 'centertop';
            app.AfterModulationPanel.Title = 'After Modulation';
            app.AfterModulationPanel.BackgroundColor = [1 1 1];
            app.AfterModulationPanel.FontName = 'Cambria Math';
            app.AfterModulationPanel.FontWeight = 'bold';
            app.AfterModulationPanel.Position = [644 14 664 355];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.AfterModulationPanel);
            title(app.UIAxes3, '')
            xlabel(app.UIAxes3, 'Time')
            ylabel(app.UIAxes3, 'Amplitude')
            app.UIAxes3.FontName = 'Cambria Math';
            app.UIAxes3.XGrid = 'on';
            app.UIAxes3.YGrid = 'on';
            app.UIAxes3.BackgroundColor = [1 1 1];
            app.UIAxes3.Position = [12 17 641 311];

            % Create CarrierSignalPanel
            app.CarrierSignalPanel = uipanel(app.CarrierSignalTab);
            app.CarrierSignalPanel.TitlePosition = 'centertop';
            app.CarrierSignalPanel.Title = 'Carrier Signal';
            app.CarrierSignalPanel.BackgroundColor = [1 1 1];
            app.CarrierSignalPanel.FontName = 'Cambria Math';
            app.CarrierSignalPanel.FontWeight = 'bold';
            app.CarrierSignalPanel.Position = [13 14 618 355];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.CarrierSignalPanel);
            title(app.UIAxes2, '')
            xlabel(app.UIAxes2, 'Time')
            ylabel(app.UIAxes2, 'Amplitude')
            app.UIAxes2.FontName = 'Cambria Math';
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.BackgroundColor = [1 1 1];
            app.UIAxes2.Position = [8 141 602 191];

            % Create VariationPanelForUserDefinedFunction
            app.VariationPanelForUserDefinedFunction = uipanel(app.CarrierSignalPanel);
            app.VariationPanelForUserDefinedFunction.TitlePosition = 'centertop';
            app.VariationPanelForUserDefinedFunction.Title = 'Variation Panel [For User Defined Function]';
            app.VariationPanelForUserDefinedFunction.BackgroundColor = [1 1 1];
            app.VariationPanelForUserDefinedFunction.SizeChangedFcn = createCallbackFcn(app, @VariationPanelForUserDefinedFunctionSizeChanged, true);
            app.VariationPanelForUserDefinedFunction.FontName = 'Cambria Math';
            app.VariationPanelForUserDefinedFunction.FontWeight = 'bold';
            app.VariationPanelForUserDefinedFunction.Position = [13 10 592 124];

            % Create CarrierFrequencyHzSliderLabel
            app.CarrierFrequencyHzSliderLabel = uilabel(app.VariationPanelForUserDefinedFunction);
            app.CarrierFrequencyHzSliderLabel.HorizontalAlignment = 'center';
            app.CarrierFrequencyHzSliderLabel.FontName = 'Cambria Math';
            app.CarrierFrequencyHzSliderLabel.FontWeight = 'bold';
            app.CarrierFrequencyHzSliderLabel.Position = [232 63 130 22];
            app.CarrierFrequencyHzSliderLabel.Text = 'Carrier Frequency (Hz)';

            % Create CarrierFrequencyHzSlider
            app.CarrierFrequencyHzSlider = uislider(app.VariationPanelForUserDefinedFunction);
            app.CarrierFrequencyHzSlider.Limits = [1000 10000];
            app.CarrierFrequencyHzSlider.ValueChangedFcn = createCallbackFcn(app, @CarrierFrequencyHzSliderValueChanged, true);
            app.CarrierFrequencyHzSlider.ValueChangingFcn = createCallbackFcn(app, @CarrierFrequencyHzSliderValueChanging, true);
            app.CarrierFrequencyHzSlider.Position = [27 56 533 3];
            app.CarrierFrequencyHzSlider.Value = 2200;

            % Create OutputSignalTab
            app.OutputSignalTab = uitab(app.TabGroup);
            app.OutputSignalTab.Title = 'Output Signal';
            app.OutputSignalTab.BackgroundColor = [1 1 1];

            % Create OutputresponseofuserdefinedTransmittedSignalPanel
            app.OutputresponseofuserdefinedTransmittedSignalPanel = uipanel(app.OutputSignalTab);
            app.OutputresponseofuserdefinedTransmittedSignalPanel.TitlePosition = 'centertop';
            app.OutputresponseofuserdefinedTransmittedSignalPanel.Title = 'Output response of  user defined Transmitted Signal';
            app.OutputresponseofuserdefinedTransmittedSignalPanel.BackgroundColor = [1 1 1];
            app.OutputresponseofuserdefinedTransmittedSignalPanel.FontName = 'Cambria Math';
            app.OutputresponseofuserdefinedTransmittedSignalPanel.FontWeight = 'bold';
            app.OutputresponseofuserdefinedTransmittedSignalPanel.Position = [606 31 707 321];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.OutputresponseofuserdefinedTransmittedSignalPanel);
            title(app.UIAxes4, '')
            xlabel(app.UIAxes4, 'Time')
            ylabel(app.UIAxes4, 'Amplitude')
            app.UIAxes4.FontName = 'Cambria Math';
            app.UIAxes4.XGrid = 'on';
            app.UIAxes4.YGrid = 'on';
            app.UIAxes4.BackgroundColor = [1 1 1];
            app.UIAxes4.Position = [4 10 687 285];

            % Create VariationPanelForuserdefinedSignal
            app.VariationPanelForuserdefinedSignal = uipanel(app.OutputSignalTab);
            app.VariationPanelForuserdefinedSignal.TitlePosition = 'centertop';
            app.VariationPanelForuserdefinedSignal.Title = 'Variation Panel [For user defined Signal]';
            app.VariationPanelForuserdefinedSignal.BackgroundColor = [1 1 1];
            app.VariationPanelForuserdefinedSignal.FontName = 'Cambria Math';
            app.VariationPanelForuserdefinedSignal.FontWeight = 'bold';
            app.VariationPanelForuserdefinedSignal.Position = [6 198 592 105];

            % Create CarrierFrequencyHzSlider_2Label
            app.CarrierFrequencyHzSlider_2Label = uilabel(app.VariationPanelForuserdefinedSignal);
            app.CarrierFrequencyHzSlider_2Label.HorizontalAlignment = 'center';
            app.CarrierFrequencyHzSlider_2Label.FontName = 'Cambria Math';
            app.CarrierFrequencyHzSlider_2Label.FontWeight = 'bold';
            app.CarrierFrequencyHzSlider_2Label.Position = [231 50 130 22];
            app.CarrierFrequencyHzSlider_2Label.Text = 'Carrier Frequency (Hz)';

            % Create CarrierFrequencyHzSlider_2
            app.CarrierFrequencyHzSlider_2 = uislider(app.VariationPanelForuserdefinedSignal);
            app.CarrierFrequencyHzSlider_2.Limits = [1000 10000];
            app.CarrierFrequencyHzSlider_2.ValueChangedFcn = createCallbackFcn(app, @CarrierFrequencyHzSlider_2ValueChanged, true);
            app.CarrierFrequencyHzSlider_2.Position = [26 40 533 3];
            app.CarrierFrequencyHzSlider_2.Value = 2200;

            % Create OutputGainForuserdefinedSignalPanel
            app.OutputGainForuserdefinedSignalPanel = uipanel(app.OutputSignalTab);
            app.OutputGainForuserdefinedSignalPanel.TitlePosition = 'centertop';
            app.OutputGainForuserdefinedSignalPanel.Title = 'Output Gain [For user defined Signal]';
            app.OutputGainForuserdefinedSignalPanel.BackgroundColor = [1 1 1];
            app.OutputGainForuserdefinedSignalPanel.FontName = 'Cambria Math';
            app.OutputGainForuserdefinedSignalPanel.FontWeight = 'bold';
            app.OutputGainForuserdefinedSignalPanel.Position = [8 74 590 105];

            % Create FrequencyHzSlider_3
            app.FrequencyHzSlider_3 = uislider(app.OutputGainForuserdefinedSignalPanel);
            app.FrequencyHzSlider_3.Limits = [1 10];
            app.FrequencyHzSlider_3.ValueChangedFcn = createCallbackFcn(app, @FrequencyHzSlider_3ValueChanged, true);
            app.FrequencyHzSlider_3.Position = [21 44 533 3];
            app.FrequencyHzSlider_3.Value = 1;

            % Create CarrierFrequencyHzSlider_2Label_2
            app.CarrierFrequencyHzSlider_2Label_2 = uilabel(app.OutputGainForuserdefinedSignalPanel);
            app.CarrierFrequencyHzSlider_2Label_2.HorizontalAlignment = 'center';
            app.CarrierFrequencyHzSlider_2Label_2.FontName = 'Cambria Math';
            app.CarrierFrequencyHzSlider_2Label_2.FontWeight = 'bold';
            app.CarrierFrequencyHzSlider_2Label_2.Position = [259.5 55 69 22];
            app.CarrierFrequencyHzSlider_2Label_2.Text = 'Output Gain';

            % Create PLLDemodulatorTab
            app.PLLDemodulatorTab = uitab(app.TabGroup);
            app.PLLDemodulatorTab.Title = 'PLL Demodulator';
            app.PLLDemodulatorTab.BackgroundColor = [1 1 1];

            % Create PhaseDetectorOutputPanel
            app.PhaseDetectorOutputPanel = uipanel(app.PLLDemodulatorTab);
            app.PhaseDetectorOutputPanel.TitlePosition = 'centertop';
            app.PhaseDetectorOutputPanel.Title = 'Phase Detector Output';
            app.PhaseDetectorOutputPanel.BackgroundColor = [1 1 1];
            app.PhaseDetectorOutputPanel.FontName = 'Cambria Math';
            app.PhaseDetectorOutputPanel.FontWeight = 'bold';
            app.PhaseDetectorOutputPanel.Position = [11 28 642 329];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.PhaseDetectorOutputPanel);
            title(app.UIAxes5, '')
            xlabel(app.UIAxes5, 'Time')
            ylabel(app.UIAxes5, 'Amplitude')
            app.UIAxes5.XGrid = 'on';
            app.UIAxes5.YGrid = 'on';
            app.UIAxes5.BackgroundColor = [1 1 1];
            app.UIAxes5.Position = [12 22 614 280];

            % Create VCOVoltageControlledOscillatorOutputPanel
            app.VCOVoltageControlledOscillatorOutputPanel = uipanel(app.PLLDemodulatorTab);
            app.VCOVoltageControlledOscillatorOutputPanel.TitlePosition = 'centertop';
            app.VCOVoltageControlledOscillatorOutputPanel.Title = 'VCO [Voltage Controlled Oscillator] Output';
            app.VCOVoltageControlledOscillatorOutputPanel.BackgroundColor = [1 1 1];
            app.VCOVoltageControlledOscillatorOutputPanel.FontName = 'Cambria Math';
            app.VCOVoltageControlledOscillatorOutputPanel.FontWeight = 'bold';
            app.VCOVoltageControlledOscillatorOutputPanel.Position = [667 28 642 329];

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.VCOVoltageControlledOscillatorOutputPanel);
            title(app.UIAxes6, '')
            xlabel(app.UIAxes6, 'Time')
            ylabel(app.UIAxes6, 'Amplitude')
            app.UIAxes6.XGrid = 'on';
            app.UIAxes6.YGrid = 'on';
            app.UIAxes6.BackgroundColor = [1 1 1];
            app.UIAxes6.Position = [14 22 614 280];

            % Create VoiceInputTab
            app.VoiceInputTab = uitab(app.TabGroup);
            app.VoiceInputTab.Title = 'Voice Input';
            app.VoiceInputTab.BackgroundColor = [1 1 1];

            % Create ActionCenterPanel
            app.ActionCenterPanel = uipanel(app.VoiceInputTab);
            app.ActionCenterPanel.TitlePosition = 'centertop';
            app.ActionCenterPanel.Title = 'Action Center';
            app.ActionCenterPanel.BackgroundColor = [1 1 1];
            app.ActionCenterPanel.FontName = 'Cambria Math';
            app.ActionCenterPanel.FontWeight = 'bold';
            app.ActionCenterPanel.FontSize = 14;
            app.ActionCenterPanel.Position = [12 13 1296 358];

            % Create UIAxes7
            app.UIAxes7 = uiaxes(app.ActionCenterPanel);
            title(app.UIAxes7, 'Output response of  voice recorded Transmitted Signal')
            xlabel(app.UIAxes7, 'Time')
            ylabel(app.UIAxes7, 'Amplitude')
            app.UIAxes7.FontName = 'Cambria Math';
            app.UIAxes7.XGrid = 'on';
            app.UIAxes7.YGrid = 'on';
            app.UIAxes7.BackgroundColor = [1 1 1];
            app.UIAxes7.Position = [523 9 766 321];

            % Create VariationPanel
            app.VariationPanel = uipanel(app.ActionCenterPanel);
            app.VariationPanel.TitlePosition = 'centertop';
            app.VariationPanel.Title = 'Variation Panel';
            app.VariationPanel.BackgroundColor = [1 1 1];
            app.VariationPanel.FontName = 'Cambria Math';
            app.VariationPanel.FontWeight = 'bold';
            app.VariationPanel.Position = [12 18 501 302];

            % Create GainSliderLabel
            app.GainSliderLabel = uilabel(app.VariationPanel);
            app.GainSliderLabel.HorizontalAlignment = 'right';
            app.GainSliderLabel.FontName = 'Cambria Math';
            app.GainSliderLabel.FontWeight = 'bold';
            app.GainSliderLabel.Position = [238 114 29 22];
            app.GainSliderLabel.Text = 'Gain';

            % Create GainSlider
            app.GainSlider = uislider(app.VariationPanel);
            app.GainSlider.Limits = [1 10];
            app.GainSlider.ValueChangedFcn = createCallbackFcn(app, @GainSliderValueChanged, true);
            app.GainSlider.Position = [16 102 465 3];
            app.GainSlider.Value = 3;

            % Create CarrierFrequencyHzSlider_3Label
            app.CarrierFrequencyHzSlider_3Label = uilabel(app.VariationPanel);
            app.CarrierFrequencyHzSlider_3Label.HorizontalAlignment = 'right';
            app.CarrierFrequencyHzSlider_3Label.FontName = 'Cambria Math';
            app.CarrierFrequencyHzSlider_3Label.FontWeight = 'bold';
            app.CarrierFrequencyHzSlider_3Label.Position = [186 195 130 22];
            app.CarrierFrequencyHzSlider_3Label.Text = 'Carrier Frequency (Hz)';

            % Create CarrierFrequencyHzSlider_3
            app.CarrierFrequencyHzSlider_3 = uislider(app.VariationPanel);
            app.CarrierFrequencyHzSlider_3.Limits = [1000 10000];
            app.CarrierFrequencyHzSlider_3.ValueChangedFcn = createCallbackFcn(app, @CarrierFrequencyHzSlider_3ValueChanged, true);
            app.CarrierFrequencyHzSlider_3.Position = [24 184 448 3];
            app.CarrierFrequencyHzSlider_3.Value = 3250;

            % Create RecordSignalButton
            app.RecordSignalButton = uibutton(app.VariationPanel, 'push');
            app.RecordSignalButton.ButtonPushedFcn = createCallbackFcn(app, @RecordSignalButtonPushed, true);
            app.RecordSignalButton.BackgroundColor = [0.0902 0.4588 0.4275];
            app.RecordSignalButton.FontName = 'Cambria Math';
            app.RecordSignalButton.FontColor = [1 1 1];
            app.RecordSignalButton.Position = [201 14 111 33];
            app.RecordSignalButton.Text = 'Record Signal';

            % Create VoiceRecordingDurationis5secondLabel
            app.VoiceRecordingDurationis5secondLabel = uilabel(app.VariationPanel);
            app.VoiceRecordingDurationis5secondLabel.HorizontalAlignment = 'center';
            app.VoiceRecordingDurationis5secondLabel.FontName = 'Cambria Math';
            app.VoiceRecordingDurationis5secondLabel.FontWeight = 'bold';
            app.VoiceRecordingDurationis5secondLabel.FontColor = [1 0 0];
            app.VoiceRecordingDurationis5secondLabel.Position = [130 250 242 22];
            app.VoiceRecordingDurationis5secondLabel.Text = '*** Voice Recording Duration is 5 second ***';

            % Create ModulationOutputSwitchLabel
            app.ModulationOutputSwitchLabel = uilabel(app.VariationPanel);
            app.ModulationOutputSwitchLabel.HorizontalAlignment = 'center';
            app.ModulationOutputSwitchLabel.FontName = 'Cambria Math';
            app.ModulationOutputSwitchLabel.FontWeight = 'bold';
            app.ModulationOutputSwitchLabel.Position = [30.5 228 107 22];
            app.ModulationOutputSwitchLabel.Text = 'Modulation Output';

            % Create ModulationOutputSwitch
            app.ModulationOutputSwitch = uiswitch(app.VariationPanel, 'slider');
            app.ModulationOutputSwitch.Position = [73 214 20 8];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = communication_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
