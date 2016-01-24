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
   
   function stickSlipIndexes  = compareStickSlipIndexes(timeInterval_sec, statesData) 
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
   
   Comments about this program go here:  
   
   Here we are comparing StickSlipIndexApproach1 and StickSlipIndexApproach2
         
   %}
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    % Default Arguments in case the user does not specify any argument  
    
    if nargin < 1
    timeInterval_sec =3;
    statesData = 'RigStatesForSampleData1'; 
    end
        
    if nargin < 2
    statesData = 'RigStatesForSampleData1'; 
    end
    
    timeInterval_sec
   
     % Load the dataset into memory
     
     rawDataAllChannels = load (fullfile(pwd, 'InputData', 'SampleData1'));

     if (nargin<2)
        rigStatesForSampleData1 = load('-ascii', fullfile(pwd, 'InputData', statesData));
     end   
  
     % Do the comparison here
     
     figure(1);
     stickSlipIndex1 = computeStickSlipIndexApproach1;
     
     figure(2);
     stickSlipIndex2 = computeStickSlipIndexApproach2;
          
     % End of comparison
       
     % Export the data to a CSV file. 
    
     fullfile(pwd, 'OutputResults', 'AnalysisResults.csv' );
             
     outfileName = fullfile(pwd, 'OutputResults', 'AnalysisResults.csv' );
     dataToExport = [rawDataAllChannels,rigStatesForSampleData1,stickSlipIndex1, stickSlipIndex2]; 
     header='Block Height(feet),Flow Out(%),Hookload(klbf),Top Drive Speed(RPM),Strokes Per Minute #1,Strokes Per Minute #2,Standpipe Pressure (psi),Top Drive Torque (ftlb),Rig State Code,Stick Slip Index (Torque Based), Stick Slip Index (Speed Based)'; 
     dlmwrite(outfileName,header,'delimiter','');
     dlmwrite(outfileName,dataToExport,'delimiter',',','-append');
  
     % Plot the charts
     
     figure(3); 
     subplot(2,1,1);
     plot(stickSlipIndex1,'g');
     title (sprintf('Stick Slip Index (Torque Based)'));
     xlabel('Data Instance (sec)');
     ylabel('Stick Slip Index (Torque Based)');
     
     subplot(2,1,2);
     plot(stickSlipIndex2, 'k');
     title (sprintf('Stick Slip Index (Speed Based)'));
     xlabel('Data Instance (sec)');
     ylabel('Stick Slip Index (Speed Based)');
     
    
   end
   
   