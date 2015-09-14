package org.wso2.carbon.apimgt.rest.api.model;


import io.swagger.annotations.*;
import com.fasterxml.jackson.annotation.JsonProperty;


@ApiModel(description = "")
public class ErrorListItem  {
  
  private Long code = null;
  private String message = null;

  
  /**
   **/
  @ApiModelProperty(required = true, value = "")
  @JsonProperty("code")
  public Long getCode() {
    return code;
  }
  public void setCode(Long code) {
    this.code = code;
  }

  
  /**
   * Description about individual errors occurred
   **/
  @ApiModelProperty(required = true, value = "Description about individual errors occurred")
  @JsonProperty("message")
  public String getMessage() {
    return message;
  }
  public void setMessage(String message) {
    this.message = message;
  }

  

  @Override
  public String toString()  {
    StringBuilder sb = new StringBuilder();
    sb.append("class ErrorListItem {\n");
    
    sb.append("  code: ").append(code).append("\n");
    sb.append("  message: ").append(message).append("\n");
    sb.append("}\n");
    return sb.toString();
  }
}
