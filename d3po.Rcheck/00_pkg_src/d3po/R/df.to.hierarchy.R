#' Conversion from data.frame to hierarchy
#' 
#' Creates a hierarchy in list format from an edge list data.frame.
#' 
#' @param ancestry.df data.frame containing edge data for all parents/children.
#' @param leaf.df data.frame containing values for nodes without children.
#' @param parent.column Name of column in ancestry.df containing parent nodes. Defaults to "parent".
#' @param child.column Name of column in ancestry.df containing child nodes. Defaults to "child".
#' @param id.column Name of column in leaf.df containing node names. Defaults to "id".
#' @param value.column Name of column in leaf.df containing leaf values. Defaults to "value".
#' 
#' @return A list representation of the hierarchy, which can be converted to JSON representation with \link{jsonlite}{toJSON}.
#' 
#' @examples
#' data(flare)
#' 
#' df.to.hierarchy(flare$ancestry.df, flare$leaf.df)
#' 
#' @export

df.to.hierarchy <-
  function(ancestry.df, leaf.df,
           parent.column = "parent", child.column = "child", id.column = "id", value.column = "value"){
    
    # Parse arguments and select columns
    ancestry.df = ancestry.df[,c(parent.column, child.column)]
    names(ancestry.df) = c("parent", "child")
    leaf.df = leaf.df[,c(id.column, value.column)]
    names(leaf.df) = c("id", "value")
    
    leaf.list = as.list(leaf.df$value)
    names(leaf.list) = leaf.df$id
    
    # Create structure
    result = list()
    address.list = list()
    
    for (i in 1:nrow(ancestry.df)){
      parent = ancestry.df$parent[i]
      child = ancestry.df$child[i]
      
      parent.exists = parent %in% names(address.list)
      child.exists = child %in% names(address.list)
      
      if (!parent.exists){
        address.list[[parent]] = c(parent, "children")
        
        result[[parent]] = list(name = parent, children = list())
        if (child.exists){
          # Get child address before making updates
          child.node.string = paste0("result", paste0("[[\"", utils::head(address.list[[child]], -1), "\"]]", collapse = ""))
          
          # Resolve addresses including child
          address.list = lapply(address.list, function(v) unlist(lapply(as.list(v), function(s) if(s == child) c(address.list[[parent]], s) else s)))
          
          # Add child node to parent node in result and remove original child node
          result[[parent]][["children"]][[child]] = list(name = child, children = eval(parse(text = child.node.string)))
          eval(parse(text = paste0(child.node.string, " = NULL")))
        } else{
          address.list[[child]] = c(address.list[[parent]], child, "children")
          result[[parent]][["children"]][[child]] = list(name = child, children = list())
        }
      } else{
        if (child.exists){
          # Get child address before making updates
          child.node.string = paste0("result", paste0("[[\"", utils::head(address.list[[child]], -1), "\"]]", collapse = ""))
          
          # Resolve addresses including child
          address.list = lapply(address.list, function(v) unlist(lapply(as.list(v), function(s) if(s == child) c(address.list[[parent]], s) else s)))
          
          # Add child node to parent node in result and remove original child node
          result[[parent]][["children"]][[child]] = list(name = child, children = eval(parse(text = child.node.string)))
          eval(parse(text = paste0(child.node.string, " = NULL")))
        } else{
          address.list[[child]] = c(address.list[[parent]], child, "children")
          eval(parse(text = paste0("result", paste0("[[\"", utils::head(address.list[[child]], -1), "\"]]", collapse = ""), " = list(name = child, children = list())")))
        }
      }
    }
    
    # Fill in values
    for (i in 1:nrow(leaf.df)){
      id = leaf.df$id[i]
      eval(parse(text = paste0("result", paste0("[[\"", utils::head(address.list[[id]], -1), "\"]]", collapse = ""), "[[\"children\"]] = NULL")))
      eval(parse(text = paste0("result", paste0("[[\"", utils::head(address.list[[id]], -1), "\"]]", collapse = ""), "[[\"value\"]] = leaf.list[[id]]")))
    }
    
    # Make all children lists unnamed
    unname.children = function(node){
      if ("children" %in% names(node)){
        children = names(node$children)
        for (child in children){
          node[["children"]][[child]] = unname.children(node[["children"]][[child]])
        }
        node$children = unname(node$children)
      }
      return(node)
    }
    result = unname(result)
    result = unname.children(result[[1]])
    
    return(result)
  }
