classdef Perfect_assignment_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        GraphpresentationdemoUIFigure  matlab.ui.Figure
        Panel                          matlab.ui.container.Panel
        SourcesSlider                  matlab.ui.control.Slider
        SourcesSliderLabel             matlab.ui.control.Label
        TargetsSlider                  matlab.ui.control.Slider
        TargetsSliderLabel             matlab.ui.control.Label
        PreviousMatchButton            matlab.ui.control.Button
        NextmatchButton                matlab.ui.control.Button
        CreategraphButton              matlab.ui.control.Button
        UIAxes                         matlab.ui.control.UIAxes
    end

    properties (Access = public)
        h % Description
        g % Graph
        p % Plot
        tn = 5; % Target nodes amount
        sn = 5; % Source nodes amount
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            axis(app.UIAxes,'off');
            createGraph3(app);
        end

        % Button pushed function: CreategraphButton
        function createGraph3(app, event)
            tn = app.tn;
            sn = app.sn;

            a = rand(tn,sn)>.25;
            
            adj_a = [zeros(tn,tn), zeros(tn,sn);
                     a', zeros(sn,sn)];
            
            app.g = digraph(adj_a);
            app.g.Edges.LWidths = app.g.Edges.Weight;            
            
            app.p = plot(app.UIAxes, app.g);
            app.p.XData(1:tn) = 1;
            app.p.XData((tn+1):end) = 2;
            app.p.YData(1:tn) = linspace(0,1,tn);
            app.p.YData((tn+1):end) = linspace(0,1,sn);
            app.p.MarkerSize = 10;
            app.p.Marker = 's';
            app.p.ArrowSize = 10;
            app.p.ArrowPosition = 0.15;
    
            tc = repmat([1 0 0], tn, 1);
            sc = repmat([0 1 0], sn, 1);
            app.p.NodeColor = [tc; sc];
            
            app.p.EdgeColor = [0.1 0.1 0.1];
            app.p.LineWidth = app.g.Edges.LWidths;

            text(app.UIAxes, app.p.XData -.005, app.p.YData +.02, app.p.NodeLabel, ...
                'VerticalAlignment','Bottom',...
                'HorizontalAlignment', 'left',...
                'FontSize', 12);
            app.p.NodeLabel = {};
           
            title(app.UIAxes, 'Bipartite graph perfect assignment', 'FontWeight','Normal','FontSize',20, 'FontAngle', 'italic', 'Color', [0.2 0.2 0.2]);

        end

        % Button pushed function: NextmatchButton
        function NextmatchButtonPushed3(app, event)
            
        end

        % Callback function
        function FindbestpathButtonPushed2(app, event)
            
        end

        % Button pushed function: PreviousMatchButton
        function PreviousMatchButtonPushed(app, event)
            app.g.Nodes.NodeColors = rand(app.na) * indegree(app.g);
            app.p.NodeCData = app.g.Nodes.NodeColors;
            app.p.EdgeColor = [0.5 0.5 0.5];
        end

        % Value changed function: TargetsSlider
        function TargetsSliderValueChanged(app, event)
            app.tn = round(app.TargetsSlider.Value);
            createGraph3(app);
        end

        % Value changed function: SourcesSlider
        function SourcesSliderValueChanged(app, event)
            app.sn = round(app.SourcesSlider.Value);
            createGraph3(app);           
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create GraphpresentationdemoUIFigure and hide until all components are created
            app.GraphpresentationdemoUIFigure = uifigure('Visible', 'off');
            app.GraphpresentationdemoUIFigure.AutoResizeChildren = 'off';
            app.GraphpresentationdemoUIFigure.Color = [0.651 0.651 0.651];
            app.GraphpresentationdemoUIFigure.Position = [100 100 1008 646];
            app.GraphpresentationdemoUIFigure.Name = 'Graph presentation demo';
            app.GraphpresentationdemoUIFigure.Resize = 'off';

            % Create UIAxes
            app.UIAxes = uiaxes(app.GraphpresentationdemoUIFigure);
            ylabel(app.UIAxes, {''; ''})
            app.UIAxes.FontName = 'Arial';
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.FontSize = 16;
            app.UIAxes.Clipping = 'off';
            app.UIAxes.Position = [19 22 823 601];

            % Create Panel
            app.Panel = uipanel(app.GraphpresentationdemoUIFigure);
            app.Panel.AutoResizeChildren = 'off';
            app.Panel.TitlePosition = 'centertop';
            app.Panel.BackgroundColor = [0.651 0.651 0.651];
            app.Panel.Position = [850 22 143 592];

            % Create CreategraphButton
            app.CreategraphButton = uibutton(app.Panel, 'push');
            app.CreategraphButton.ButtonPushedFcn = createCallbackFcn(app, @createGraph3, true);
            app.CreategraphButton.BackgroundColor = [0.9294 0.7098 0.4902];
            app.CreategraphButton.FontSize = 14;
            app.CreategraphButton.Tooltip = {'Create new graph with selected sources and targets amount'};
            app.CreategraphButton.Position = [11 545 119 33];
            app.CreategraphButton.Text = 'Create graph';

            % Create NextmatchButton
            app.NextmatchButton = uibutton(app.Panel, 'push');
            app.NextmatchButton.ButtonPushedFcn = createCallbackFcn(app, @NextmatchButtonPushed3, true);
            app.NextmatchButton.BackgroundColor = [0.9412 0.851 0.4902];
            app.NextmatchButton.FontSize = 14;
            app.NextmatchButton.Enable = 'off';
            app.NextmatchButton.Position = [10 500 123 33];
            app.NextmatchButton.Text = 'Next match';

            % Create PreviousMatchButton
            app.PreviousMatchButton = uibutton(app.Panel, 'push');
            app.PreviousMatchButton.ButtonPushedFcn = createCallbackFcn(app, @PreviousMatchButtonPushed, true);
            app.PreviousMatchButton.BackgroundColor = [0.5098 0.8784 0.8784];
            app.PreviousMatchButton.FontSize = 14;
            app.PreviousMatchButton.Enable = 'off';
            app.PreviousMatchButton.Position = [12 450 119 33];
            app.PreviousMatchButton.Text = {'Previous Match'; ''};

            % Create TargetsSliderLabel
            app.TargetsSliderLabel = uilabel(app.Panel);
            app.TargetsSliderLabel.HorizontalAlignment = 'right';
            app.TargetsSliderLabel.FontSize = 16;
            app.TargetsSliderLabel.FontColor = [1 0 0];
            app.TargetsSliderLabel.Position = [40 195 58 22];
            app.TargetsSliderLabel.Text = 'Targets';

            % Create TargetsSlider
            app.TargetsSlider = uislider(app.Panel);
            app.TargetsSlider.Limits = [2 8];
            app.TargetsSlider.Orientation = 'vertical';
            app.TargetsSlider.ValueChangedFcn = createCallbackFcn(app, @TargetsSliderValueChanged, true);
            app.TargetsSlider.MinorTicks = [];
            app.TargetsSlider.Tooltip = {'Targets amount'};
            app.TargetsSlider.Position = [55 29 3 151];
            app.TargetsSlider.Value = 5;

            % Create SourcesSliderLabel
            app.SourcesSliderLabel = uilabel(app.Panel);
            app.SourcesSliderLabel.HorizontalAlignment = 'right';
            app.SourcesSliderLabel.FontSize = 14;
            app.SourcesSliderLabel.FontColor = [0 1 0];
            app.SourcesSliderLabel.Position = [40 410 57 22];
            app.SourcesSliderLabel.Text = 'Sources';

            % Create SourcesSlider
            app.SourcesSlider = uislider(app.Panel);
            app.SourcesSlider.Limits = [2 8];
            app.SourcesSlider.Orientation = 'vertical';
            app.SourcesSlider.ValueChangedFcn = createCallbackFcn(app, @SourcesSliderValueChanged, true);
            app.SourcesSlider.MinorTicks = [];
            app.SourcesSlider.Tooltip = {'Sources amount'};
            app.SourcesSlider.Position = [54 244 3 151];
            app.SourcesSlider.Value = 5;

            % Show the figure after all components are created
            app.GraphpresentationdemoUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Perfect_assignment_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.GraphpresentationdemoUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.GraphpresentationdemoUIFigure)
        end
    end
end