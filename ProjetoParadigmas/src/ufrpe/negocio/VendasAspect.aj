package ufrpe.negocio;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.util.List;

import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import ufrpe.negocio.beans.ItemVenda;
import ufrpe.negocio.beans.NotaFiscal;
import ufrpe.negocio.exception.NegocioException;
import ufrpe.repositorio.IRepositorioVenda;
import ufrpe.repositorio.RepositorioVenda;

public aspect VendasAspect {

	private IRepositorioVenda repoVenda = RepositorioVenda.getInstancia();


	pointcut GerarNF():
		call(void ControladorVenda.gerarNotaFiscal(*));
	after() returning: GerarNF(){
		salvarArquivo();
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Nota fiscal gerada");
		alert.setHeaderText(null);
		alert.setContentText("Nota fiscal gerada com sucesso!");
		alert.showAndWait();
	}

	pointcut InserirItem():
		call(void ControladorVenda.inserir(*));
	after() throwing(NegocioException e): InserirItem(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}

	pointcut RemoverItem():
		call(void ControladorVenda.remover(*));
	after() throwing(NegocioException e): RemoverItem(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}

	pointcut EncerrarPedido():
		call(void ControladorVenda.encerrarPedido());
	after() throwing(NegocioException e): EncerrarPedido(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}

	pointcut ListarItensVenda():
		call(List<ItemVenda> ControladorVenda.listarItensVenda());
	after() throwing(NegocioException e): ListarItensVenda(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}

	pointcut CancelarVenda():
		call(void ControladorVenda.resetarPedido());
	after() returning: CancelarVenda(){
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Venda cancelada");
		alert.setHeaderText(null);
		alert.setContentText("Venda cancelada com sucesso!");
		alert.showAndWait();
	}
	pointcut ListarNotasFiscais():
		call( List<NotaFiscal> ControladorVenda.listarNotasFiscais());
	after() throwing(NegocioException e): ListarNotasFiscais(){
		Alert alert = new Alert(AlertType.ERROR);
		alert.setTitle("Erro!");
		alert.setHeaderText(null);
		alert.setContentText(e.getMessage());
		alert.showAndWait();
		e.printStackTrace();
	}

	public void salvarArquivo() {
		if (!(repoVenda == null)) {
			File salvar = new File("RepositorioVenda.dat");
			try {
				if (!salvar.exists()) {
					salvar.createNewFile();
				}

				FileOutputStream fos = new FileOutputStream(salvar);
				ObjectOutputStream oos = new ObjectOutputStream(fos);

				oos.writeObject(repoVenda);
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
