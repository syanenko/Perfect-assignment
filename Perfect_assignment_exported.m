classdef Perfect_assignment_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        GraphpresentationdemoUIFigure  matlab.ui.Figure
        CaseSlider                     matlab.ui.control.Slider
        CaseSliderLabel                matlab.ui.control.Label
        Panel                          matlab.ui.container.Panel
        SourcesSlider                  matlab.ui.control.Slider
        SourcesSliderLabel             matlab.ui.control.Label
        TargetsSlider                  matlab.ui.control.Slider
        TargetsSliderLabel             matlab.ui.control.Label
        UIAxes                         matlab.ui.control.UIAxes
    end

    properties (Access = public)
        h % Description
        g % Graph
        p % Plot
        tn = 5; % Target nodes amount
        sn = 5; % Source nodes amount
        vi = 1; % Adjacency matrix varian index
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            axis(app.UIAxes,'off');
            createGraph3(app);
        end

        % Callback function
        function createGraph3(app, event)
            tn = app.tn;
            sn = app.sn;
            vi = app.vi;

            maxd = max(tn,sn);
            mind = min(tn,sn);
            
            d = diag(ones(1, maxd));
            p = perms([1:mind]);

            ca = size(p,1);
            app.CaseSlider.Limits = [1, ca];
            
            a = d(:, p([vi],:));
            
            adj_a = [zeros(maxd,maxd), zeros(maxd,mind);
                     a', zeros(mind,mind)];

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
            header = sprintf('Bipartite graph perfect assignment (%d %s' , ca, 'cases)');
            title(app.UIAxes, header, 'FontWeight','Normal','FontSize',20, 'FontAngle', 'italic', 'Color', [0.2 0.2 0.2]);

        end

        % Callback function
        function FindbestpathButtonPushed2(app, event)
            
        end

        % Callback function
        function PreviousMatchButtonPushed(app, event)
            app.g.Nodes.NodeColors = rand(app.na) * indegree(app.g);
            app.p.NodeCData = app.g.Nodes.NodeColors;
            app.p.EdgeColor = [0.5 0.5 0.5];
        end

        % Value changed function: TargetsSlider
        function TargetsSliderValueChanged(app, event)
            app.tn = round(app.TargetsSlider.Value);
            app.vi = 1;
            app.CaseSlider.Value = app.vi;
            createGraph3(app);
        end

        % Value changed function: SourcesSlider
        function SourcesSliderValueChanged(app, event)
            app.sn = round(app.SourcesSlider.Value);
            app.vi = 1;
            app.CaseSlider.Value = app.vi;
            createGraph3(app);
        end

        % Value changed function: CaseSlider
        function CaseSliderValueChanged(app, event)
            app.vi = round(app.CaseSlider.Value);
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
            app.UIAxes.Position = [13 77 829 546];

            % Create Panel
            app.Panel = uipanel(app.GraphpresentationdemoUIFigure);
            app.Panel.AutoResizeChildren = 'off';
            app.Panel.TitlePosition = 'centertop';
            app.Panel.BackgroundColor = [0.651 0.651 0.651];
            app.Panel.Position = [857 86 122 528];

            % Create TargetsSliderLabel
            app.TargetsSliderLabel = uilabel(app.Panel);
            app.TargetsSliderLabel.HorizontalAlignment = 'right';
            app.TargetsSliderLabel.FontSize = 16;
            app.TargetsSliderLabel.FontColor = [1 0 0];
            app.TargetsSliderLabel.Position = [40 244 58 22];
            app.TargetsSliderLabel.Text = 'Targets';

            % Create TargetsSlider
            app.TargetsSlider = uislider(app.Panel);
            app.TargetsSlider.Limits = [2 10];
            app.TargetsSlider.Orientation = 'vertical';
            app.TargetsSlider.ValueChangedFcn = createCallbackFcn(app, @TargetsSliderValueChanged, true);
            app.TargetsSlider.MinorTicks = [];
            app.TargetsSlider.Tooltip = {'Targets amount'};
            app.TargetsSlider.Position = [48 34 3 195];
            app.TargetsSlider.Value = 5;

            % Create SourcesSliderLabel
            app.SourcesSliderLabel = uilabel(app.Panel);
            app.SourcesSliderLabel.HorizontalAlignment = 'right';
            app.SourcesSliderLabel.FontSize = 14;
            app.SourcesSliderLabel.FontColor = [0 1 0];
            app.SourcesSliderLabel.Position = [32 488 57 22];
            app.SourcesSliderLabel.Text = 'Sources';

            % Create SourcesSlider
            app.SourcesSlider = uislider(app.Panel);
            app.SourcesSlider.Limits = [2 10];
            app.SourcesSlider.Orientation = 'vertical';
            app.SourcesSlider.ValueChangedFcn = createCallbackFcn(app, @SourcesSliderValueChanged, true);
            app.SourcesSlider.MinorTicks = [];
            app.SourcesSlider.Tooltip = {'Sources amount'};
            app.SourcesSlider.Position = [46 297 3 176];
            app.SourcesSlider.Value = 5;

            % Create CaseSliderLabel
            app.CaseSliderLabel = uilabel(app.GraphpresentationdemoUIFigure);
            app.CaseSliderLabel.HorizontalAlignment = 'right';
            app.CaseSliderLabel.FontSize = 14;
            app.CaseSliderLabel.Position = [13 35 38 22];
            app.CaseSliderLabel.Text = 'Case';

            % Create CaseSlider
            app.CaseSlider = uislider(app.GraphpresentationdemoUIFigure);
            app.CaseSlider.Limits = [1 1000];
            app.CaseSlider.ValueChangedFcn = createCallbackFcn(app, @CaseSliderValueChanged, true);
            app.CaseSlider.MinorTicks = [];
            app.CaseSlider.Tooltip = {'Matching case index'};
            app.CaseSlider.Position = [63 58 916 3];
            app.CaseSlider.Value = 1;

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