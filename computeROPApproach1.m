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
   
   function rateOfPenetration_ftperhr  = computeROPApproach1(timeInterval_sec =30, statesData = "RigStatesForSampleData1") 
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
   
   Comments about this program go here:  
   
   This is approach 1 of calculation ROP: More details Later
   
   Metadata needed for this approach: 
   
   1. timeInterval_sec
   2. rigState
      
   Other Comments:
         
   %}
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
      
     % Load the dataset into memory
     
     h = waitbar(0, "Loading Data"); 
     load (fullfile(pwd, "InputData", "SampleData1"));

     if (nargin<2)
        rigStatesForSampleData1 = load("-ascii", fullfile(pwd, "InputData", statesData));
     endif   

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
     
     waitbar(0.3, h, "Performing Calculations"); 
         
     for i=1:timeInterval_sec
          rateOfPenetration_ftperhr(i) = NaN;
     end 
     
     
     for i=(timeInterval_sec+1):length(blockHeight_feet)
        
        if(rigStatesForSampleData1(i)==2)
          rateOfPenetration_ftperhr(i) = 3600.0/3.28*((blockHeight_feet(i-timeInterval_sec)-blockHeight_feet(i)))/timeInterval_sec;
        else
         rateOfPenetration_ftperhr(i) = 0;
        endif
        
     end 
     
     rateOfPenetration_ftperhr = rateOfPenetration_ftperhr';
     
     % End of calculation
       
     % Export the data to a CSV file. 
     
     waitbar(0.7, h, "Writing Data to CSV file"); 
     
     fullfile(pwd, "OutputResults", "AnalysisResults.csv" )
             
     outfileName = fullfile(pwd, "OutputResults", "AnalysisResults.csv" );
     dataToExport = [rawDataAllChannels,rigStatesForSampleData1,rateOfPenetration_ftperhr]; 
     header='Block Height(feet),Flow Out(%),Hookload(klbf),Top Drive Speed(RPM),Strokes Per Minute #1,Strokes Per Minute #2,Standpipe Pressure (psi),Top Drive Torque (ftlb),Rig State Code,Rate Of Penetration(ft/hr)'; 
     dlmwrite(outfileName,header,'delimiter','');
     dlmwrite(outfileName,dataToExport,'delimiter',',','-append');
     
     waitbar(1, h, "All Complete");
   
     close(h);
     
     % Plot the charts
        
     subplot(3,3,1);
     plot(blockHeight_feet,"g");
     title (sprintf('Block Height'));
     xlabel('Data Instance (sec)');
     ylabel('Block Height(feet)');
     
     subplot(3,3,2);
     plot(flowOut_percent, "k");
     title (sprintf('Flow Out (percent)'));
     xlabel('Data Instance (sec)');
     ylabel('Flow Out(%)');
     
     subplot(3,3,3);
     plot(hookLoad_klbf, "b");
     title (sprintf('Hookload(klbf)'));
     xlabel('Data Instance (sec)');
     ylabel('Hookload(klbf)');
     
     subplot(3,3,4);
     plot(topdriveSpeed_rpm, "m");
     title (sprintf('Top Drive Speed(RPM)'));
     xlabel('Data Instance (sec)');
     ylabel('Top Drive Speed(RPM)');
     
     subplot(3,3,5);
     plot(strokesPerMinute1_spm, "r");
     title (sprintf('Strokes Per Minute #1'));
     xlabel('Data Instance (sec)');
     ylabel('Strokes Per Minute #1');
     
     subplot(3,3,6);
     plot(strokesPerMinute2_spm, "b");
     title (sprintf('Strokes Per Minute #2'));
     xlabel('Data Instance (sec)');
     ylabel('Strokes Per Minute #2');
     
     subplot(3,3,7);
     plot(standPipePressure_psi, "g");
     title (sprintf('Standpipe Pressure (psi)'));
     xlabel('Data Instance (sec)');
     ylabel('Standpipe Pressure (psi)');
     
     subplot(3,3,8);
     plot(topDriveTorque_ftlb, "k");
     title (sprintf('Top Drive Torque (ftlb)'));
     xlabel('Data Instance (sec)');
     ylabel('Top Drive Torque (ftlb)');
   
     subplot(3,3,9);
     plot(rateOfPenetration_ftperhr, "m");
     title (sprintf('Rate Of Penetration(ft/hr)'));
     xlabel('Data Instance (sec)');
     ylabel('Rate Of Penetration(ft/hr)');
     
     
 endfunction
   
   