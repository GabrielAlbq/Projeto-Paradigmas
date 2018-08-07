package ufrpe.negocio;

import java.util.List;

import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import ufrpe.negocio.beans.Produto;
import ufrpe.negocio.exception.IdentificacaoInvalidaException;
import ufrpe.negocio.exception.NegocioException;

public aspect EstoqueAspect {
	
	pointcut exceptionListarEstoque() :
		call(List<Produto> ControladorEstoque.listarProduto());
	after() throwing(NegocioException e): exceptionListarEstoque(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao listar!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	pointcut exceptionSubtrairEstoque():
		call(void ControladorEstoque.subtrairProduto(*,*));
	after() throwing(NegocioException e): exceptionSubtrairEstoque(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	pointcut exceptionInserirEstoque():
		call(void ControladorEstoque.inserir(*));
	after() throwing(RuntimeException re): exceptionInserirEstoque(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao cadastrar!");
		alert.setHeaderText(null);
		alert.setContentText(re.getMessage());
		alert.showAndWait();
		re.printStackTrace();
	}
	
	//@after(args) throwing() : pointcut_expression {}
//	pointcut exceptionEstoque2():
//		call(void ufrpe.gui.model.ControladorAdmin.listarProduto());
//	after(): exceptionEstoque2(){
//		System.out.println("exception");
//	}
	
//	pointcut excepEstoque(List<Produto> produtos): 
//		call(List<Produto> ControladorEstoque.listarProduto()) && args (produtos);
//	before(List<Produto> produtos) throws InstanciaInexistenteException: excepEstoque(produtos){
//		if(produtos.isEmpty() == true){
//			throw new InstanciaInexistenteException("\nNao ha produtos cadastrados!\n");
//		}
//	}
//	pointcut excepEstoque(List<Produto> produtos):
//		call(List<Produto> RepositorioEstoque.listar()) && args (produtos);
//	before(List<Produto> produtos): excepEstoque(produtos){
//		if(produtos.isEmpty() == true){
//			
//		}
//	}
//	pointcut exceptionEstoque(List<Produto> produtos):
//		call(List<Produto> ControladorEstoque.listarProduto()) && args (produtos);
//	before(List<Produto> produtos ): set(List<Produto> ControladorEstoque.listaProduto()) && args(produtos) exceptionEstoque(produtos){
//		
//	}
	pointcut exceptEstoque(Produto prod):
		call(void ControladorEstoque.inserir(*)) && args(prod);
	before(Produto prod) throws NegocioException: exceptEstoque(prod){
		if(prod == null){
			throw new RuntimeException("\nInstancia de Produto nula\n");
//			Alert alert = new Alert(AlertType.ERROR);
//			alert.setTitle("Erro ao cadastrar!");
//			alert.setHeaderText(null);
//			//alert.setContentText(e.getMessage());
//			alert.showAndWait();
//			//e.printStackTrace();
		}
		if (prod.getNome().isEmpty() == true) {
			throw new RuntimeException("\nString do Nome do Produto nula, adicione um nome!\n");
		}
		if (prod.getCodigo() <= 0) {
			throw new IdentificacaoInvalidaException("\nCodigo (" + prod.getCodigo() + ") invalido\n");
		}
//		if (retornarPosicao(prod.getCodigo()) != -1) {
//			throw new InstanciaRepetidaException("\nProduto de codigo(" + prod.getCodigo() + ") ja cadastrado\n");
//		}
	}
//	
//	public Alert alerta(){
//		after
		//Alert alert = new Alert(AlertType.ERROR);
//		alert.setTitle("Erro ao cadastrar!");
//		alert.setHeaderText(null);
//		//alert.setContentText(e.getMessage());
//		alert.showAndWait();
//		//e.printStackTrace();
	//}
	
	
	
	
}
