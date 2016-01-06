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
   
   function bitDepth_feet  = computeBitDepthApproach1(currentBitDepth_feet, statesData) 
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
   
   Comments about this program go here:  
   
   This is approach 1 to calculating bit depth: More details Later
   
   Metadata needed for this approach: 
   
   1. currentBitDepth_feet
   2. rigState
      
   Other Comments:
         
   %}
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
     % Default Arguments in case the user does not specify any argument  
    
      if nargin < 1
      currentBitDepth_feet =3000;
      statesData = 'RigStatesForSampleData1'; 
      end
          
      if nargin < 2
      statesData = 'RigStatesForSampleData1'; 
      end
      
      currentBitDepth_feet
      
     % Load the dataset into memory
     
     h = waitbar(0, 'Loading Data'); 
     rawDataAllChannels = load (fullfile(pwd, 'InputData', 'SampleData1'));

     if (nargin<2)
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
         
     bitDepth_feet(1) = currentBitDepth_feet;
           
     for i= 2:length(blockHeight_feet)
        
        if(rigStatesForSampleData1(i)==2)
          bitDepth_feet(i) = bitDepth_feet(i-1)+(blockHeight_feet(i-1)-blockHeight_feet(i));
        else
          bitDepth_feet(i) = bitDepth_feet(i-1);
        end
        
     end 
     
     bitDepth_feet = bitDepth_feet';
     
     % End of calculation
       
     % Export the data to a CSV file. 
     
     waitbar(0.7, h, 'Writing Data to CSV file'); 
             
     outfileName = fullfile(pwd, 'OutputResults', 'AnalysisResults.csv' );
     dataToExport = [rawDataAllChannels,rigStatesForSampleData1,bitDepth_feet]; 
     header='Block Height(feet),Flow Out(%),Hookload(klbf),Top Drive Speed(RPM),Strokes Per Minute #1,Strokes Per Minute #2,Standpipe Pressure (psi),Top Drive Torque (ftlb),Rig State Code,Bit Depth(ft)'; 
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
     plot(bitDepth_feet, 'm');
     title (sprintf('Bit Depth (feet)'));
     xlabel('Data Instance (sec)');
     ylabel('Bit Depth (feet)');
     
     
   end
   
   