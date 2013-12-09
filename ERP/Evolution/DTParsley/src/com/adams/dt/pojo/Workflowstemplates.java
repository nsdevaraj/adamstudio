package com.adams.dt.pojo;

import java.io.Serializable; 

public class Workflowstemplates implements Serializable {

    static final long serialVersionUID = 103844514947365244L;
    
    private int workflowTemplateId;
    private Integer phaseTemplateFK;
    private String taskCode;
    private String taskLabel;
    private String taskLabelTodo;
    private String optionPrevLabel;
    private String optionNextLabel;
    private String optionJumpLabel;
    private String optionLoopLabel;
    private String optionStopLabel;
    private int defaultEstimatedTime;
    
    private int profileFK;
    private Workflowstemplates nextTaskFk;
    private Workflowstemplates prevTaskFk;
    private Workflowstemplates jumpToTaskFk;
    private Workflowstemplates loopFk; 
    private int workflowFK;
	public int getWorkflowFK() {
		return workflowFK;
	}
	public void setWorkflowFK(int workflowFK) {
		this.workflowFK = workflowFK;
	}
	public Workflowstemplates() {    	
    }
	/* workflow_template_ID, PK */
    public int getWorkflowTemplateId() {
        return workflowTemplateId;
    }

    /* workflow_template_ID, PK */
    public void setWorkflowTemplateId(int workflowTemplateId) {
        this.workflowTemplateId = workflowTemplateId;
    }
 
    /* task_code */
    public String getTaskCode() {
        return taskCode;
    }

    /* task_code */
    public void setTaskCode(String taskCode) {
        this.taskCode = taskCode;
    }

    /* task_label */
    public String getTaskLabel() {
        return taskLabel;
    }

    /* task_label */
    public void setTaskLabel(String taskLabel) {
        this.taskLabel = taskLabel;
    }

    /* task_label_todo */
    public String getTaskLabelTodo() {
        return taskLabelTodo;
    }

    /* task_label_todo */
    public void setTaskLabelTodo(String taskLabelTodo) {
        this.taskLabelTodo = taskLabelTodo;
    }

    /* option_prev_label */
    public String getOptionPrevLabel() {
        return optionPrevLabel;
    }

    /* option_prev_label */
    public void setOptionPrevLabel(String optionPrevLabel) {
        this.optionPrevLabel = optionPrevLabel;
    }
 

    /* option_next_label */
    public String getOptionNextLabel() {
        return optionNextLabel;
    }

    /* option_next_label */
    public void setOptionNextLabel(String optionNextLabel) {
        this.optionNextLabel = optionNextLabel;
    }
 
    /* option_jump_label */
    public String getOptionJumpLabel() {
        return optionJumpLabel;
    }

    /* option_jump_label */
    public void setOptionJumpLabel(String optionJumpLabel) {
        this.optionJumpLabel = optionJumpLabel;
    }
 
    /* option_loop_label */
    public String getOptionLoopLabel() {
        return optionLoopLabel;
    }

    /* option_loop_label */
    public void setOptionLoopLabel(String optionLoopLabel) {
        this.optionLoopLabel = optionLoopLabel;
    }
  
	/* option_stop_label */
    public String getOptionStopLabel() {
        return optionStopLabel;
    }

    /* option_stop_label */
    public void setOptionStopLabel(String optionStopLabel) {
        this.optionStopLabel = optionStopLabel;
    } 
	 
	public Integer getPhaseTemplateFK() {
		return phaseTemplateFK;
	}
	public void setPhaseTemplateFK(Integer phaseTemplateFK) {
		this.phaseTemplateFK = phaseTemplateFK;
	}
	public int getProfileFK() {
		return profileFK;
	}
	public void setProfileFK(int profileFK) {
		this.profileFK = profileFK;
	}
	public Workflowstemplates getNextTaskFk() {
		return nextTaskFk;
	}

	public void setNextTaskFk(Workflowstemplates nextTaskFk) {
		this.nextTaskFk = nextTaskFk;
	}

	public Workflowstemplates getPrevTaskFk() {
		return prevTaskFk;
	}

	public void setPrevTaskFk(Workflowstemplates prevTaskFk) {
		this.prevTaskFk = prevTaskFk;
	}

	public Workflowstemplates getJumpToTaskFk() {
		return jumpToTaskFk;
	}

	public void setJumpToTaskFk(Workflowstemplates jumpToTaskFk) {
		this.jumpToTaskFk = jumpToTaskFk;
	}

	public Workflowstemplates getLoopFk() {
		return loopFk;
	}

	public void setLoopFk(Workflowstemplates loopFk) {
		this.loopFk = loopFk;
	}
	public int getDefaultEstimatedTime() {
		return defaultEstimatedTime;
	}
	public void setDefaultEstimatedTime(int defaultEstimatedTime) {
		this.defaultEstimatedTime = defaultEstimatedTime;
	}


}