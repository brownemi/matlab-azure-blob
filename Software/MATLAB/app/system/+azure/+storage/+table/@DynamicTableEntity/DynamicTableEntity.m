classdef DynamicTableEntity < azure.object
    % DYNAMICTABLEENTITY Dynamic Table Entity for use with the Table Operations
    % This class specifies the entity that is used in the TableOperations with
    % the Azure table storage.
    %
    % For details of mapping of MATLAB datatype to Table Properties see
    % the TableResult class documentation.
    
    % Copyright 2017 The MathWorks, Inc.

    properties
        partitionKey='';
        rowKey=''
    end

    methods
        %% Constructor
        function obj = DynamicTableEntity(~, varargin)
        end

        %% Initialize
        function initialize(obj, varargin)
            % Imports
            import com.microsoft.azure.storage.table.*;
            import java.util.HashMap;

            % Read the properties of the object and create the java property
            oProps = setdiff(properties(obj),{'rowKey','partitionKey'});

            % Create the HashMap
            hMap = java.util.HashMap;
            for pCount = 1:numel(oProps)
                % Check the datatype of the give property
                % see: https://azure.github.io/azure-sdk-for-java/com/microsoft/azure/storage/table/EntityProperty.html
                % EntityProperty represents single typed property and overloads
                % the constructor that sets the type and value based on the input
                % The MATLAB Java marshalling presents the right value to the API
                % in most cases
                % A marshaling is used only type primitives are supported
                % Creating a null EdmType Entity is not supported by the
                % Java API
                if isempty(obj.(oProps{pCount})) && ~(ischar(obj.(oProps{pCount})) || isstring(obj.(oProps{pCount})))
                    logObj = Logger.getLogger();
                    write(logObj,'error','Empty values are supported for strings and char vectors only');
                else
                    if isa(obj.(oProps{pCount}),'datetime')
                        if numel(obj.(oProps{pCount})) == 1
                            dateJ = java.util.Date(int64(posixtime(obj.(oProps{pCount}))*1000));
                            hMap.put(oProps{pCount},EntityProperty(dateJ));
                        else
                            logObj = Logger.getLogger();
                            write(logObj,'error','datetime values must be scalar and not empty');
                        end
                    elseif isa(obj.(oProps{pCount}),'string') && numel(obj.(oProps{pCount})) ~= 1
                        logObj = Logger.getLogger();
                        write(logObj,'error','string values must be scalar');
                    else
                        hMap.put(oProps{pCount},EntityProperty(obj.(oProps{pCount})));
                    end
                end
            end

            % Create a handle to the Java entity
            obj.Handle = DynamicTableEntity(obj.partitionKey, obj.rowKey, '*' , hMap);

        end
    end

end %class