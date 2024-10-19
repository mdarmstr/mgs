function intr(U)
    %% Scores in the first two columns, classes in the last
    mns = [mean(U(U(:,3)==1,1:2)); mean(U(U(:,3)==2,1:2))];
    
    hold on;
    
    %% Pick random pair in each class
    sz1 = length(U(U(:,3)==1,1));
    sz2 = length(U(U(:,3)==2,1));
    
    cnt = 0;
    filename = 'animated_plot.gif'; % Name of the output GIF file
    
    % Create the figure
    figure;
    
    for ii = 1:1000
        % Random indices
        rnd1 = randi(sz1, 1);
        rnd2 = sz1 + randi(sz2, 1);
        
        % Plot the lines
        plot([mns(1, 1), U(rnd1, 1)], [mns(1, 2), U(rnd1, 2)], 'b');
        hold on;
        
        % Scatter plot with transparency and marker type '.'
        scatter(U(:,1), U(:,2), [], U(:,3), 'filled', 'Marker', 'o', 'MarkerFaceAlpha', 0.3);
        
        plot([mns(2, 1), U(rnd2, 1)], [mns(2, 2), U(rnd2, 2)], 'r');
        
        % Calculate vectors and pseudo-inverse solution
        mnv = mns(2, :)' - mns(1, :)';
        X = [U(rnd1, 1:2)' - mns(1, :)', -U(rnd2, 1:2)' + mns(2, :)'];
        b = pinv(X) * mnv;
    
        % Update count if condition is met
        if abs(b(1)) < 1 && abs(b(2)) < 1
            cnt = cnt + 1;
        end
        
        % Normalize the count
        normalized_cnt = cnt / ii;
        
        % Display the normalized count on the plot
        text(0.1, 0.9, ['Normalized Count: ', num2str(normalized_cnt)], 'Units', 'normalized', 'FontSize', 12, 'Color', 'black');
        
        % Capture the frame
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
    
        % Write to the GIF file
        if ii == 1
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append');
        end
        
        hold off;
    end
    
    % Close the figure
    close;
end
