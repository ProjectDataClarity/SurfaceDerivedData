   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
   
   Copyright [2016] [Dandan Zheng] [Project Data Clarity]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
   %}
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   function rateOfPenetration_hrperft  = computeCutFootROPApproach1(timeInterval_sec, currentBitDepth_feet, statesData) 
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
   
   Comments about this program go here:  
   
   This is CutFoot_1Ft Approach of calculation ROP: More details Later
   
   Metadata needed for this approach: 
   
   1. timeInterval_sec
   2. currentBitDepth_feet
   3. rigState
      
   Other Comments:
         
   %}
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    % Default Arguments in case the user does not specify any argument  
    
    if nargin < 1
    timeInterval_sec =30;
    statesData = 'RigStatesForSampleData1'; 
    end
    
    if nargin < 2
    currentBitDepth_feet =3000;
    statesData = 'RigStatesForSampleData1'; 
    end
      
    if nargin < 3
    statesData = 'RigStatesForSampleData1'; 
    end
   
   
     % Load the dataset into memory
     
     h = waitbar(0, 'Loading Data'); 
     rawDataAllChannels = load (fullfile(pwd, 'InputData', 'SampleData1'));

     if (nargin<3)
        rigStatesForSampleData1 = load('-ascii', fullfile(pwd, 'InputData', statesData));
     end   

     % Separate arrays are created for each data channel for ease of use. 
     % Not all of the channels will be needed for all derived data calculations. 
     
     blockHeight_feet = rawDataAllChannels(:,1);
     flowOut_percent = rawDataAllChannels(:,2);
     hookLoad_klbf = rawDataAllChannels(:,3);
     topdriveSpeed_rpm = rawDataAllChannels(:,4);
     strokesPerMinute1_spm = rawDataAllChannels(:,5);
     strokesPerMinute2_spm = rawDataAllChannels(:,6);
     standPipePressure_psi = rawDataAllChannels(:,7);
     topDriveTorque_ftlb = rawDataAllChannels(:,8);
   
     % Do the calculation here
     
     waitbar(0.3, h, 'Performing Calculations'); 
     
     %Hole Depth Calculation
     HoleDepth_feet(1) = currentBitDepth_feet;
           
     for i= 2:length(blockHeight_feet)
        
        if(rigStatesForSampleData1(i)==2)
          HoleDepth_feet(i) = HoleDepth_feet(i-1)+(blockHeight_feet(i-1)-blockHeight_feet(i));
        else
          HoleDepth_feet(i) = HoleDepth_feet(i-1);
        end
        
     end 
     
     HoleDepth_feet = HoleDepth_feet';
     
     
     %sp = starting point for calculating cut foot ROP _1 ft
        sp = 2;
        while HoleDepth_feet(sp)- HoleDepth_feet(1) < 1 
                rateOfPenetration_hrperft(sp-1) = NaN;
                sp = sp+1;
        end 
        
 
    PreviousHoleDepth = HoleDepth_feet(sp);
    PreviousTime = timeInterval_sec*sp;
    CurrentCutFootROP = NaN;
    
    %CutFootROP in Hr/Ft
     for i= sp:length(blockHeight_feet)
         rateOfPenetration_hrperft(i) = NaN; 
         CurrentHoleDepth = HoleDepth_feet(i);
         CurrentTime = timeInterval_sec*i;
         % when rig state is 'not drilling', ROP is shown as NaN
         if   rigStatesForSampleData1(i)~=2 
             rateOfPenetration_hrperft(i) = NaN;
             PreviousHoleDepth = HoleDepth_feet(i);
             PreviousTime = timeInterval_sec*i;
             CurrentCutFootROP = NaN;
         end
         % if drilling
         if (rigStatesForSampleData1(i)==2) && CurrentHoleDepth - PreviousHoleDepth >= 1 
            rateOfPenetration_hrperft(i) = (CurrentTime-PreviousTime)/3600/(CurrentHoleDepth - PreviousHoleDepth);
            CurrentCutFootROP = rateOfPenetration_hrperft(i);
            PreviousHoleDepth = CurrentHoleDepth;
            PreviousTime = CurrentTime;
         else
             rateOfPenetration_hrperft(i) = CurrentCutFootROP;
         end
         
     end
     
     
     rateOfPenetration_hrperft = rateOfPenetration_hrperft';
     
     % End of calculation
       
     % Export the data to a CSV file. 
     
     waitbar(0.7, h, 'Writing Data to CSV file'); 
     
     fullfile(pwd, 'OutputResults', 'AnalysisResults.csv' )
             
     outfileName = fullfile(pwd, 'OutputResults', 'AnalysisResults.csv' );
     dataToExport = [rawDataAllChannels,rigStatesForSampleData1,rateOfPenetration_hrperft]; 
     header='Block Height(feet),Flow Out(%),Hookload(klbf),Top Drive Speed(RPM),Strokes Per Minute #1,Strokes Per Minute #2,Standpipe Pressure (psi),Top Drive Torque (ftlb),Rig State Code,Rate Of Penetration(hr/ft)'; 
     dlmwrite(outfileName,header,'delimiter','');
     dlmwrite(outfileName,dataToExport,'delimiter',',','-append');
     
     waitbar(1, h, 'All Complete');
   
     close(h);
     
     % Plot the charts
        
     subplot(3,3,1);
     plot(blockHeight_feet,'g');
     title (sprintf('Block Height'));
     xlabel('Data Instance (sec)');
     ylabel('Block Height(feet)');
     
     subplot(3,3,2);
     plot(flowOut_percent, 'k');
     title (sprintf('Flow Out (percent)'));
     xlabel('Data Instance (sec)');
     ylabel('Flow Out(%)');
     
     subplot(3,3,3);
     plot(hookLoad_klbf, 'b');
     title (sprintf('Hookload(klbf)'));
     xlabel('Data Instance (sec)');
     ylabel('Hookload(klbf)');
     
     subplot(3,3,4);
     plot(topdriveSpeed_rpm, 'm');
     title (sprintf('Top Drive Speed(RPM)'));
     xlabel('Data Instance (sec)');
     ylabel('Top Drive Speed(RPM)');
     
     subplot(3,3,5);
     plot(strokesPerMinute1_spm, 'r');
     title (sprintf('Strokes Per Minute #1'));
     xlabel('Data Instance (sec)');
     ylabel('Strokes Per Minute #1');
     
     subplot(3,3,6);
     plot(strokesPerMinute2_spm, 'b');
     title (sprintf('Strokes Per Minute #2'));
     xlabel('Data Instance (sec)');
     ylabel('Strokes Per Minute #2');
     
     subplot(3,3,7);
     plot(standPipePressure_psi, 'g');
     title (sprintf('Standpipe Pressure (psi)'));
     xlabel('Data Instance (sec)');
     ylabel('Standpipe Pressure (psi)');
     
     subplot(3,3,8);
     plot(topDriveTorque_ftlb, 'k');
     title (sprintf('Top Drive Torque (ftlb)'));
     xlabel('Data Instance (sec)');
     ylabel('Top Drive Torque (ftlb)');
   
     subplot(3,3,9);
     plot(rateOfPenetration_hrperft, 'm');
     title (sprintf('Rate Of Penetration(hr/ft)'));
     xlabel('Data Instance (sec)');
     ylabel('Rate Of Penetration(hr/ft)');
     
     
   end
   
   