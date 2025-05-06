classdef mso44
    % TEKTRONIX_MDO4 Interface class
    % Chiara Mahlstedt (Chiara.Mahlstedt@haw-hamburg.de)
    % 24.03.25
    properties
        mso
    end

    methods
        function obj = mso44()
            
               mso = instrfind('Type', 'visa-usb', 'RsrcName', 'TCPIP0::169.254.9.46::inst0', 'Tag', '');
                %interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', addr, 'Tag', '');
                % Create the VISA-USB object if it does not exist
                % otherwise use the object that was found.
                if isempty(mso)
                    mso = visa('ni', 'TCPIP0::169.254.9.46::inst0');
                    %interfaceObj = visa('ni', addr);
                else
                    fclose(mso);
                    mso = mso(1);
                end
                fopen(mso);
                obj.mso=mso;
                
        
        end
   
    
    function data = getAcquisition(obj)
     %Queries the current acquisition state.
      msg = "ACQuire?";
      data = query(obj.mso,msg);
      disp("The acquisition state is"+msg);
    end

    function data = setFastAcqMode(obj, mode)
        %Sets the waveform grading for fast acquisition mode
        if strcmp(mode,"NORM")
            msg= "ACQuire:FASTAcq:PALEtte NORMal";

        elseif strcmp(mode,"TEMP")
            msg="ACQuire:FASTAcq:PALEtte TEMPerature";

        elseif strcmp(mode,"SPEC")
            msg="ACQuire:FASTAcq:PALEtte SPECtral";

        elseif strcmp(mode,"INV")
            msg="ACQuire:FASTAcq:PALEtte INVErted";

        else
            disp("ERROR, wrong Argument. Mode can only be set to NORM, TEMP, SPEC, INV.");
        end

        disp("The mode has been set to "+mode);
        data = query(obj.mso,msg);

    end

    function data =  getFastAcqMode(obj)

        %gets the waveform grading for fast acquisition mode

        msg= "ACQuire:FASTAcq:PALEtte?";
        disp("The mode is "+msg);
        data = query(obj.mso,msg);
    end

    function data = setAcgState(obj, state)
        %Sets the state of fast acquisition mode.
        if strcmp(state,"ON")
            msg= "ACQuire:FASTAcq:STATE ON";

        elseif strcmp(state,"OFF")
            msg="ACQuire:FASTAcq:STATE OFF";

        elseif state == 0
            msg="ACQuire:FASTAcq:STATE OFF";

        else
            msg="ACQuire:FASTAcq:STATE OFF";

        end

        disp("The state has been set to "+state);
        data = query(obj.mso,msg);

    end

    function data = getAcgState(obj)
     %Queries the state of fast acquisition mode.

     msg= "ACQuire:FASTAcq:STATE?";
     disp("The state is "+msg);
     data = query(obj.mso,msg);

    end

    function data = getAcqSampRate(obj)
    % This command sets or queries the selected acquisition mode of the instrument

        msg = "ACQuire:MAXSamplerate?";
        disp("The maximum samplerate is "+msg);
        data = query(obj.mso,msg);
    end

    function data = setAcqMode(obj, mode)
        % This command sets the selected acquisition mode of the instrument.
        possibleMode = ["SAM", "PEAK", "HIR", "AVE", "ENV"];  %{SAMple|PEAKdetect|HIRes|AVErage|ENVelope}

        if ismember(mode, possibleMode)

            msg = "ACQuire:MODe" +mode;
        else
            disp( "Wrong Argument");
        end
        data = query(obj.mso,msg);
    end

    function data = getAcqMode(obj)
        % This command queries the selected acquisition mode of the instrument.
        msg = "ACQuire:MODe?";
        disp("The acquire mode is "+msg);
        data = query(obj.mso,msg);
    end

    function data = getAcqNumaCq(obj)
        % This query-only command returns the number of waveform acquisitions that have occurred
        % since the last time acquisitions were stopped.
        msg = "ACQuire:NUMACq?";
        disp("The Number of waveform acqusitions was "+msg);
        data = query(obj.mso,msg);
    end
    
    function data = setAcqNumaVg(obj, num)
         % This command sets the number of waveform acquisitions that make up an averaged waveform. 
         % Ranges from 2 to 10240.

         msg = "ACQuire:NUMAVg "+num;
         disp("The Number of waveform acqusitions was set to "+num);
         data = query(obj.mso,msg);
    end

    function data = getAcqNumaVg(obj)
         % This command sets the number of waveform acquisitions that make up an averaged waveform. 
         % Ranges from 2 to 10240.

         msg = "ACQuire:NUMAVg?";
         disp("The number of acqusitions is "+msg);
         data = query(obj.mso,msg);
    end
    
    function data = getFramesAcquired(obj)
        % This query returns the number sof FastFrame frames which have been acquired
         msg = "ACQuire:NUMFRAMESACQuired?";
         disp("The number of acquired Frames is "+msg);
         data = query(obj.mso,msg);
    end

    
    function data = getAcqSeqCur(obj)
        % In single sequence acquisition mode, this query returns the number of acquisitions
        % or measurements in the sequence completed so far.
        msg = "ACQuire:SEQuence:CURrent?";
        disp("The number of acquisitions in the sequence is "+msg);
        data = query(obj.mso,msg);

    end

    function data = setAcqSequenceMode(obj, mode)
        % In single sequence acquisition, the single sequence stop after count is based on the
        % number of acquisitions.
        if strcmp(mode,"NUMACQs")
            msg = "ACQuire:SEQuence:MODe " + mode;
        else
            disp("Wrong Message!")
        end
        disp("The sequence acqusition mode was set to "+mode);
        data = query(obj.mso,msg);
    end

    function data = getAcqSequenceMode(obj)
        % In single sequence acquisition, the single sequence stop after count is based on the
        % number of acquisitions.

        msg = "ACQuire:SEQuence:MODe?";
        disp("The sequence acqusition mode is"+msg);
        data = query(obj.mso,msg);
    end

    function data = setAcqNumSeq(obj,number)
        
        % In single sequence acquisition mode, specify the number of acquisitions or
        % measurements that comprise the sequence. The default is 1

        msg = "ACQuire:SEQuence:NUMSEQuence "+number;
        disp("The number of acquisition in the sequence was set to "+number);
        data = query(obj.mso,msg);

    end

    function data = getAcqNumSeq(obj)
        % In single sequence acquisition mode, specify the number of acquisitions or
        % measurements that comprise the sequence. The default is 1
        
        msg = "ACQuire:SEQuence:NUMSEQuence?";
        disp("The number of acquisition in the sequence is "+msg);
        data = query(obj.mso,msg);

    end

    function data = setAcqState(obj, state)
        
        % This command starts or stops acquisitions. When state is set to ON or RUN, a
        % new acquisition will be started. If the last acquisition was a single acquisition
        % sequence, a new single sequence acquisition will be started. If the last acquisition
        % was continuous, a new continuous acquisition will be started.
        % If RUN is issued in the middle of completing a single sequence acquisition (for
        % example, averaging or enveloping), the acquisition sequence is restarted, and
        % any accumulated data is discarded. Also, the instrument resets the number of
        % acquisitions. If the RUN argument is issued while in continuous mode, a reset
        % occurs and acquired data continues to acquire.
        % If acquire:stopafter is SEQUENCE, this command leaves the instrument in single
        % sequence, unlike the run/stop button which takes the instrument out of single
        % sequence.
        
        possibleStates = ["OFF", "ON", "RUN", "STOP"];

        if ismember(state,possibleStates)
            msg = "ACQuire:STATE" +state;
            disp("The acquisition state was set to "+state);
        elseif state == 0
            msg = "ACQuire:STATE STOP";
            disp("The acquisition state was set to Stop");
        elseif state > 0
            msg = "ACQuire:STATE START";
            disp("The acquisition state was set to Start");
        else
            disp("Wrong Argument");
        end
        data = query(obj.mso,msg);

    end
        
    function data = getAcqState(obj)

        msg = "ACQuire:STATE?";
        disp ("The acq state is "+msg);
        data = query(obj.mso,msg);

    end

    function data = setAcqStopAfter(obj, mode)
        
        % This command sets whether the instrument continually acquires
        % acquisitions or acquires a single sequence. Pressing SINGLE on the front
        % panel button is equivalent to sending these commands: ACQUIRE:STOPAFTER
        % SEQUENCE and ACQUIRE:STATE 1.
        
        if strcmp(mode, "seq")
            msg = "ACQuire:STOPAfter SEQuence";
        elseif strcmp (mode, "run")
            msg = "ACQuire:STOPAfter RUNSTop";
        else
            disp("wrong Argument for mode. Try run or seq");
        end
        
        disp ("The acquisition was set to "+mode);
        data = query(obj.mso,msg);
    end
    
    function data = getAcqStopAfter(obj)
        
        msg = "ACQuire:STOPAfter?";
        disp ("The acquisition was set to "+msg);
        data = query(obj.mso,msg);
        
    end
    
    function data = setAfgAmplitude (obj, amplitude)
        %Sets the AFG amplitude in volts, peak to peak.
        
        msg = "AFG:AMPLitude" +amplitude;
        disp( "The amplitude was set to " +amplitude);
        data = query(obj.mso,msg);
        
    end
    
    function data = getAfgAmplitude (obj)
        %Queries the AFG amplitude in volts, peak to peak.
        
        msg = "AFG:AMPLitude?";
        disp( "The amplitude is " +msg);
        data = query(obj.mso,msg);
        
    end
    
    function data = setAfgArbSource(obj)
        
    end
    
    end
    end
  

