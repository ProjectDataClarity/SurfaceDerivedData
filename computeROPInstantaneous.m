   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
   
   Copyright [2016] [Pradeepkumar Ashok] [Project Data Clarity]

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
   
   function rateOfPenetration_ftperhr  = computeROPInstantaneous(statesData) 
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
   
   Comments about this program go here:  
   
   This is approach to calculating Instantaneous ROP: More details Later
   
   Metadata needed for this approach: 
   
   1. rigState
      
   Other Comments: Instantaneous ROP is independent of sampling rate.
         
   %}
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    % Default Arguments in case the user does not specify any argument  
    
    if nargin < 1
    statesData = 'RigStatesForSampleData1'; 
    end
   
     % Load the dataset into memory
     
     h = waitbar(0, 'Loading Data'); 
     rawDataAllChannels = load (fullfile(pwd, 'InputData', 'SampleData1.csv'));

     if (nargin<2)
        rigStatesForSampleData1 = load('-ascii', fullfile(pwd, 'InputData', statesData));
     end   

     % Separate arrays are created for each data channel for ease of use. 
     % Not all of the channels will be needed for all derived data calculations. 
     
     time_sec = rawDataAllChannels(:,1)
     blockHeight_feet = rawDataAllChannels(:,2);
     flowOut_percent = rawDataAllChannels(:,3);
     hookLoad_klbf = rawDataAllChannels(:,4);
     topdriveSpeed_rpm = rawDataAllChannels(:,5);
     strokesPerMinute1_spm = rawDataAllChannels(:,6);
     strokesPerMinute2_spm = rawDataAllChannels(:,7);
     standPipePressure_psi = rawDataAllChannels(:,8);
     topDriveTorque_ftlb = rawDataAllChannels(:,9);
     surveyInclination_degrees = rawDataAllChannels(:,10);
     surveyAzimuth_degrees = rawDataAllChannels(:,11);
     dataInstances_nounit = rawDataAllChannels(:,12);
   
     % Do the calculation here
     
     waitbar(0.3, h, 'Performing Calculations'); 
         
     timeIntervalCounter = 0;
     
     for i=1:length(dataInstances_nounit) 
         % If the current state is drilling 
         if(rigStatesForSampleData1(i)==2) 
              % Once it starts drilling wait until 1 data instance before outputing an ROP value. Otherwise ROP = 0
               timeIntervalCounter = timeIntervalCounter + 1;
               if(timeIntervalCounter<=1)
                  rateOfPenetration_ftperhr(i) = 0;
               else 
                  % The '1' below needs to be replaced with difference between two time instants.
                  rateOfPenetration_ftperhr(i) = ((blockHeight_feet(i-1)-blockHeight_feet(i)))/(1/3600); 
               end
         
         else 
         
           % If not drilling
           rateOfPenetration_ftperhr(i) = 0;
           timeIntervalCounter = 0; 
         
         end 
          
     end  
       
     rateOfPenetration_ftperhr = rateOfPenetration_ftperhr'; 
     
     % End of calculation
       
     % Export the data to a CSV file. 
     
     waitbar(0.7, h, 'Writing Data to CSV file'); 
     
     fullfile(pwd, 'OutputResults', 'AnalysisResults.csv' )
             
     outfileName = fullfile(pwd, 'OutputResults', 'AnalysisResults.csv' );
     dataToExport = [rawDataAllChannels,rigStatesForSampleData1,rateOfPenetration_ftperhr]; 
     header='Time(sec), Block Height(feet),Flow Out(%),Hookload(klbf),Top Drive Speed(RPM),Strokes Per Minute #1,Strokes Per Minute #2,Standpipe Pressure (psi),Top Drive Torque (ftlb),Survey Inclination (degrees), Survey Azimuth (degrees), Data Instance, Rig State Code,Instantaneous Rate Of Penetration(ft/hr)'; 
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
     plot(rateOfPenetration_ftperhr, 'm');
     title (sprintf('Instantaneous Rate Of Penetration(ft/hr)'));
     xlabel('Data Instance (sec)');
     ylabel('Instantaneous Rate Of Penetration(ft/hr)');
     
     
   end
   
   