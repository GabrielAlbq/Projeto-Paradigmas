package ufrpe.negocio;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.util.List;

import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import ufrpe.negocio.beans.Funcionario;
import ufrpe.negocio.exception.NegocioException;
import ufrpe.repositorio.IRepositorioFuncionario;
import ufrpe.repositorio.RepositorioFuncionario;

public aspect FuncionarioAspect {
	
	
	private IRepositorioFuncionario repoFuncionario = RepositorioFuncionario.getInstancia();
	
	//EXCECOES, CONFIRMACOES E PERSISTENCIA DE FUNCIONARIOS
	
	//INSERIR
	pointcut InserirFunc():
		call(void ControladorFuncionario.inserir(*));
	after() throwing(Throwable e): InserirFunc(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao cadastrar!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	after() returning: InserirFunc(){
		salvarArquivo();
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Funcionario inserido");
		alert.setHeaderText(null);
		alert.setContentText("Funcionario inserido com sucesso!");
		alert.showAndWait();
	}
	
	//REMOVER
	pointcut RemoverFunc():
		call(void ControladorFuncionario.remover(*));
	after() throwing(Throwable e): RemoverFunc(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao remover!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	after() returning: RemoverFunc(){
		salvarArquivo();
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Funcionario removido");
		alert.setHeaderText(null);
		alert.setContentText("Funcionario removido com sucesso!");
		alert.showAndWait();
	}
	
	//ALTERAR
	pointcut AlterarFunc():
		call(void ControladorFuncionario.alterar(*));
	after() throwing(Throwable e): AlterarFunc(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro ao alterar!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	after() returning: AlterarFunc(){
		salvarArquivo();
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Funcionario alterado");
		alert.setHeaderText(null);
		alert.setContentText("Funcionario alterado com sucesso!");
		alert.showAndWait();
	}
	
	//LISTAR
	pointcut ListarFunc():
		call(List<Funcionario> ControladorFuncionario.listarFuncionarios());
	after() throwing(NegocioException e): ListarFunc(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	
	//BUSCAR
	pointcut BuscarFunc():
		call(Funcionario ControladorFuncionario.buscar(*));
	after() throwing(NegocioException e): BuscarFunc(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Funcionario nao encontrado");
		alert.setHeaderText(null);
		alert.setContentText("Funcionario inexistente, verifique se o ID foi digitado corretamente!");
		alert.showAndWait();
	}
	after() returning: BuscarFunc(){
		Alert alert = new Alert(AlertType.INFORMATION);
		alert.setTitle("Funcionario encontrado!");
		alert.setHeaderText(null);
		alert.setContentText("Funcionário encontrado");
		alert.showAndWait();
	}
	//LOGIN FUNCIONARIO
	pointcut ValidarLogin():
		call(Funcionario ControladorFuncionario.validarLogin(*));
	after() throwing(Throwable e): ValidarLogin(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Falha de Login");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}
	
	//PERSISTENCIA
	
	public void salvarArquivo() {
		if (!(repoFuncionario == null)) {
			File salvar = new File("RepositorioFuncionario.dat");
			try {
				if (!salvar.exists()) {
					salvar.createNewFile();
				}

				FileOutputStream fos = new FileOutputStream(salvar);
				ObjectOutputStream oos = new ObjectOutputStream(fos);

				oos.writeObject(repoFuncionario);
				oos.flush();
				oos.close();
				fos.flush();
				fos.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}
	
}
