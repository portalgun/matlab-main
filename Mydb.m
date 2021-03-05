classdef Mydb < handle
%TODO configfile?
properties
    tcp
    bFile=0
end
properties(Constant)
    statusFName='/home/dambam/Code/mat/.cache/db_status.txt'
    stackFName='/home/dambam/Code/mat/.cache/db_stack.txt'
end
methods(Static)
%% STEP
    function obj=Mydb(bFile)
        if ~exist('bFile','var')
            obj.bFile=bFile;
        end

        obj.connect();
    end
    function step(obj,n)
        if ~exist('n','var') || isempty(n)
            n=1;
        end
        dbstep(n);
        obj.stack_main();
    end
    function step_in(obj)
        dbstep in;
        obj.stack_main();
    end
    function step_out(obj)
        dbstep out;
        obj.stack_main();
    end
%% QUIT
    function quit(obj)
        dbquit;
    end
    function quit_all(obj)
        dbquit('all');
    end
%% STOP
    function stop(obj,file,line,expr)
        if ~exist('expr','var') || isempty(expr)
            eval(['dbstop in ' file ' at ' line ';']);
        else
            eval(['dbstop in ' file ' at ' line ' if ' expr ;']);
        end
        obj.msg('dbstatus')
    end
    function stop_if(obj,exp)
        eval(['dbstop if ' expr ';']);
    end
    function stop_if_error(obj,ID)
        if  ~exist('ID','var') || isempty(ID)
            dbstop if error;
        else
            eval(['dbstop if error ' ID ';']);
        end
        obj.msg('dbstatus')
    end
    function stop_if_warn(obj,ID)
        if  ~exist('ID','var') || isempty(ID)
            dbstop if warning;
        else
            eval(['dbstop if warning ' ID ';']);
        end
        obj.msg('dbstatus')
    end
%% CLEAR
    function clear(obj,file,line,exp)
        if ~exist('expr','var') || isempty(expr)
            eval(['dbclear in ' file ' at ' line ';']);
        else
            eval(['dbsclear in ' file ' at ' line ' if ' expr ;']);
        end
        obj.msg('dbstatus')
    end
    function clear_all(obj)
        dbclear all;
        obj.msg('dbstatus')
    end
    function clear_if(obj,exp)
        eval(['dbclear if ' expr ';']);
    end
    function clear_if_error(obj,ID)
        if  ~exist('ID','var') || isempty(ID)
            eval(['dbclear_ if error;']);
        else
            eval(['dbclear_ if error ' ID ';']);
        end
        obj.msg('dbstatus')
    end
    function clear_if_warn(obj,ID)
        if  ~exist('ID','var') || isempty(ID)
            eval(['dbclear_ if warning;']);
        else
            eval(['dbclear_ if warning ' ID ';']);
        end
        obj.msg('dbstatus')
    end
%% OTHER
    function cont(obj)
        dbcont;
        obj.stack_main();
        obj.msg('dbstack')
    end
    function up(obj)
        dbup;
        % XXX
    end
    function down(obj)
        dbdown;
        % XXX
    end
    function type(obj,file,range)
        eval('dbtype ' file ' ' range ';');
        % XXX
    end
%% STATUS
    function S=status(obj)
        S=dbstatus(file,'completenames');
        % S. (name,file,line,anonymous,expression,cond,identifier)
    end
    function [ST,I]=stack(obj)
        [ST,I]=dbstack('--complete-names');
        % ST.  file, name, line
    end
end
methods(Access=private)
%% CONNECTION
    function t=connect(obj)
        obj.t=tcpclient('0.0.0.0',26097);
    end
    function msg(obj,cmd)
        write(obj.t, uint8(cmd));
    end
%% STACK
    function text = stack_main(obj)
        % name, file, line
        S=obj.stack();
        text=obj.get_stack_lines(S);

        if obj.bFile
            fname=obj.get_stack_fname();
            obj.stack_to_file(fname,text);
        else
            text=['1' newline text];
            obj.msg(text);
        end
    end
    function stack_to_file(obj,fname,text)
        cell2file(fname,text);
    end
    function text=get_stack_lines(obj,S)
        % ST.  file, name, line
        % location is at top
        [ST,I]=obj.stack();
        for i = 1:length(ST)
            name=ST(i).name;
            file=ST(i).file;
            line=ST(i).line;

            text{end+1,1}=['''' name ...
                        ''',''' file ...
                        ''',''' line ...
                        ''''];
        end

    end
    function fname=get_stack_fname(obj)
        fname=obj.stackFName;
    end
%% STATUS
    function text=status_main(obj)
        % name, file, line, anon, expr
        S=obj.status();
        text=obj.get_status_lines(S);

        if obj.bFile
            fname=obj.get_status_fname();
            obj.status_lines_to_file(fname,text);
        else
            text=['0' newline text];
            obj.msg(text);
        end
    end
    function []=status_lines_to_file(obj,fname,text)
        cell2file(fname,text);
    end
    function text=get_status_lines(obj,S)
        text=cell(0,1);
        for i = 1:length(S)
            name=S(i).name;
            file=S(i).file;
            for j = 1:length(S(i).line)
                line=S(i).line(j);
                anon=S(i).anonymous(j);
                expr=S(i).expression{j};

                text{end+1,1}=['''' name ...
                            ''',''' file ...
                            ''',''' line ...
                            ''',''' anon ...
                            ''',''' expr ...
                            ''''];
            end
        end
    end
    function fname=get_satus_fname(obj)
        fname=obj.statusFName;
    end


end
end
