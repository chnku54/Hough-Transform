function hough_transform()
    img = imread('circle_hough_image.jpg');

    % Display the input image
    figure;
    imshow(img);title('Input image');
    

    % Find the edge of the image
    
    S=[1 1 1 ; 1 1 1 ; 1 1 1];

    img_erode=imerode(img,S);
    subplot(1,3,2),imshow(img_erode);title('Eroded Image');

    imgEdge=img-img_erode;
    subplot(1,3,3),imshow(imgEdge);title('Boundary');
    
    
    imgBW = imbinarize(imgEdge);
    
    figure;    
    imshow(imgBW);title('Edge');
    
    % Perform the circular Hough Transform. Create a varible 
    %'Accumulator' to store the bin counts.    
    
    
    [m,n]=size(imgBW);
    m
    n

    Accumulator=[];
    matrix=zeros(m,n);
    %R=70;
    for R = 40:80
        matrix=zeros(m,n);
        max=0;
        for i = (R+1):(m-R)
            for j = (R+1):(n-R)
                if imgBW(i,j)==1
                    circle=imbinarize(zeros(m,n));
                    for ang = 0:0.05:2*pi
                        xp=R*cos(ang)+i;
                        yp=R*sin(ang)+j;
                        circle(round(xp),round(yp))=1;
                        matrix = matrix+circle;
                    end
                end
            end
        end
         for i = 1:m 
             for j = 1:n
                 if matrix(i,j) > max
                     max = matrix(i,j);
                     Xc = i;
                     Yc = j;
                     Rs = R; 
                     Accumulator=[Accumulator; Rs , Xc, Yc, max];
                 end 
             end
        end
    end   

    Accumulator = sortrows(Accumulator,4,'descend');
   

    % Search the count cell in 'Accumulator' and store the required
    % x,y-coordinates and the corresponding radii in three separate arrays. 

    
    Accumulator3 = Accumulator(1:7, :);
    
    Xc=Accumulator3(: , 2);
    Yc=Accumulator3(: , 3);
    max_Rs=Accumulator3(: , 1);
    
    % Plot the results using red line
    figure;
    imshow(imgBW);title('Locate the circles');
    hold on;
    for i = 1:length(Xc)
        plot(Yc(i),Xc(i),'x','LineWidth',2,'Color','red');
        viscircles([Yc(i) Xc(i)], max_Rs(i),'EdgeColor','r');
    end
    

end