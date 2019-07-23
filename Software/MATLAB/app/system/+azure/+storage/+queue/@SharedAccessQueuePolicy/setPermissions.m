function setPermissions(obj, permSet)
% SETPERMISSIONS Sets permissions for a shared access policy
% This policy is used for a Shared Access Signature. permSet
% should be an array of azure.storage.queue.SharedAccessQueuePermissions
% enumerations.
%
%   % create an array of permissions enumerations
%   permSet(1) = azure.storage.queue.SharedAccessQueuePermissions.ADD;
%   permSet(2) = azure.storage.queue.SharedAccessQueuePermissions.READ;
%   permSet(3) = azure.storage.queue.SharedAccessQueuePermissions.UPDATE;
%   % create a queue policy object
%   myPolicy = azure.storage.queue.SharedAccessQueuePolicy();
%   % set permissions on the policy
%   myPolicy.setPermissions(permSet);
%

% Copyright 2018 The MathWorks, Inc.

import java.util.EnumSet

% Create a logger object
logObj = Logger.getLogger();

% we use the EnumSet.of method to construct the EnumSet using the
% first entry and then the add methods to add further entries to this.
if numel(permSet) > 0
    switch char(permSet(1))
        case 'ADD'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.ADD);
        case 'NONE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.NONE);
        case 'PROCESSMESSAGES'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.PROCESSMESSAGES);
        case 'READ'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.READ);
        case 'UPDATE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.UPDATE);
        otherwise
            str =  char(permSet(1));
            write(logObj,'error',['Invalid SharedAccessQueuePermissions enum value: ',str]);
    end %switch
else
    write(logObj,'error','Array of input permissions is empty');
end


if numel(permSet) > 1
    for n=2:numel(permSet)
        switch char(permSet(n))
            case 'ADD'
                if ~enumSetJ.add(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.ADD)
                    write(logObj,'warning',['Error adding SharedAccessQueuePermissions enum value: ',char(permSet(n))]);
                end
            case 'NONE'
                if ~enumSetJ.add(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.NONE)
                    write(logObj,'warning',['Error adding SharedAccessQueuePermissions enum value: ',char(permSet(n))]);
                end
            case 'PROCESSMESSAGES'
                if ~enumSetJ.add(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.PROCESSMESSAGES)
                    write(logObj,'warning',['Error adding SharedAccessQueuePermissions enum value: ',char(permSet(n))]);
                end
            case 'READ'
                if ~enumSetJ.add(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.READ)
                    write(logObj,'warning',['Error adding SharedAccessQueuePermissions enum value: ',char(permSet(n))]);
                end
            case 'UPDATE'
                if ~enumSetJ.add(com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.UPDATE)
                    write(logObj,'warning',['Error adding SharedAccessQueuePermissions enum value: ',char(permSet(n))]);
                end
            otherwise
                str =  char(permSet(n));
                write(logObj,'error',['Invalid SharedAccessQueuePermissions enum value: ',str]);
        end %switch
    end
end

obj.Handle.setPermissions(enumSetJ);

end %function
