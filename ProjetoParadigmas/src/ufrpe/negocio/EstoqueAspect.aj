package ufrpe.negocio;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.util.List;

import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import ufrpe.negocio.beans.Produto;
import ufrpe.negocio.exception.NegocioException;
import ufrpe.repositorio.IRepositorioEstoque;
import ufrpe.repositorio.RepositorioEstoque;

public aspect EstoqueAspect {
	
	 private IRepositorioEstoque repoestoque = RepositorioEstoque.getInstancia();

//	 pointcut RepoEstoqueInstancia():
//		 call(RepositorioEstoque getInstancia());
//	 after() returning():RepoEstoqueInstancia(){
//		 
//	 }
	 
	//EXCECOES E CONFIRMACOES DE PROCEDIMENTO ESTOQUE
	//LISTAR
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
	//SUBTRAIR PRODUTO
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
	
	//INSERIR
	pointcut InserirEstoque():
		call(void ControladorEstoque.inserir(*));
	after() throwing(Throwable e): InserirEstoque(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao cadastrar!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	after() returning:InserirEstoque(){
		salvarArquivo(); //TODO: VERIFICAR SE ESTÁ SALVANDO
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Confirmacao de adicao");
		alert.setHeaderText(null);
		alert.setContentText("Produto adicionado com sucesso!");
		alert.showAndWait();
	}
	
	//REMOVER, EXCECAO E CONFIRMACAO
	pointcut RemoverEstoque():
		call(void ControladorEstoque.remover(*));
	after() throwing(NegocioException e): RemoverEstoque(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao remover!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	after() returning:RemoverEstoque(){
		salvarArquivo();
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Confirmacao de remocao");
		alert.setHeaderText(null);
		alert.setContentText("Produto removido com sucesso!");
		alert.showAndWait();
	}
	
	//ALTERAR
	pointcut AlterarEstoque():
		call(void ControladorEstoque.alterar(*));
	after() throwing(NegocioException e):AlterarEstoque(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao alterar!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	after() returning:AlterarEstoque(){
		salvarArquivo();
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Produto alterado");
		alert.setHeaderText(null);
		alert.setContentText("Produto alterado com sucesso!");
		alert.showAndWait();
	}

	//BUSCAR
	pointcut BuscarEstoque():
		call(Produto ControladorEstoque.buscar(*));
	after() throwing(NegocioException e): BuscarEstoque(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Produto nao encontrado");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
	}

	//PERSISTENCIA

	
	public void salvarArquivo() {
		if (!(repoestoque == null)) {
			File salvar = new File("RepositorioEstoque.dat");
			try {
				if (!salvar.exists()) {
					salvar.createNewFile();
				}

				FileOutputStream fos = new FileOutputStream(salvar);
				ObjectOutputStream oos = new ObjectOutputStream(fos);

				oos.writeObject(repoestoque);
				oos.flush();
				oos.close();
				fos.flush();
				fos.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}

	//LOGGING

}
